Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11914F2AE8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241840AbiDEIfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239346AbiDEIT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA72BABBB;
        Tue,  5 Apr 2022 01:11:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F1F660B0A;
        Tue,  5 Apr 2022 08:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85A9C385A0;
        Tue,  5 Apr 2022 08:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146286;
        bh=qYNb8JjXyt2i++J9mM15z0WcGWElh9bLpF6Ke3lC8g4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ykDjpSekVUMS31MaqHAUqlYRaEcjdwJS5mGv/sq7LlxWtAnfkvS4X+w7pA0DVKrMS
         ihd5t6CR+drJ0u+TAgSZ+SnYNKTu+Ec7bs1ntMBVs7LPDqrrMbQmNOPesmFxJST0qq
         ZCsj5GLyLiljzKsfzKNJh6RnNAfP5GX9/72P0h7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0708/1126] ice: dont allow to run ice_send_event_to_aux() in atomic ctx
Date:   Tue,  5 Apr 2022 09:24:15 +0200
Message-Id: <20220405070428.382965430@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>

[ Upstream commit 5a3156932da06f09953764de113419f254086faf ]

ice_send_event_to_aux() eventually descends to mutex_lock()
(-> might_sched()), so it must not be called under non-task
context. However, at least two fixes have happened already for the
bug splats occurred due to this function being called from atomic
context.
To make the emergency landings softer, bail out early when executed
in non-task context emitting a warn splat only once. This way we
trade some events being potentially lost for system stability and
avoid any related hangs and crashes.

Fixes: 348048e724a0e ("ice: Implement iidc operations")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Tested-by: Michal Kubiak <michal.kubiak@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_idc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index fc3580167e7b..5559230eff8b 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -34,6 +34,9 @@ void ice_send_event_to_aux(struct ice_pf *pf, struct iidc_event *event)
 {
 	struct iidc_auxiliary_drv *iadrv;
 
+	if (WARN_ON_ONCE(!in_task()))
+		return;
+
 	if (!pf->adev)
 		return;
 
-- 
2.34.1



