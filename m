Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E940A4F337B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354100AbiDEKLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343967AbiDEJQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:16:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAE4D5573;
        Tue,  5 Apr 2022 02:02:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDBA1B80DA1;
        Tue,  5 Apr 2022 09:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51750C385A0;
        Tue,  5 Apr 2022 09:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149327;
        bh=PbU3Zy+C03rpWGayUy2MlpDNrRuZYXE7DvqU86BFgbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zy5RQS2jeJG3/HZF0ek9t+LIMLyfYtclN/kiY/dWkkTvYJ1JczavbFY1pSMrKa8N2
         QN1drNQOiM5rQLJUBq0JdOERrVMoCh9jxHSgJ0rfP8y+/NUpxXX/gPLqLzlWcgCjgh
         hd4+Rn8ToMAOW5hl4K890nQgUx+GmZJas3dpoqII=
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
Subject: [PATCH 5.16 0638/1017] ice: dont allow to run ice_send_event_to_aux() in atomic ctx
Date:   Tue,  5 Apr 2022 09:25:51 +0200
Message-Id: <20220405070413.221449890@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index adcc9a251595..a2714988dd96 100644
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



