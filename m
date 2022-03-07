Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85C3A4CF96B
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236902AbiCGKEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240321AbiCGKA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:00:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A627EA3B;
        Mon,  7 Mar 2022 01:47:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05AD06122D;
        Mon,  7 Mar 2022 09:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16DCC340F5;
        Mon,  7 Mar 2022 09:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646443;
        bh=uJCPOqF2xI6+TMmEk1hZkWXqx5KU3QzRdV2V91L7ACI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SyTdki4M8yrrbk7sYhKXrwn4apKu0XtuzbBtOQ1/0uTp2vueByub2tTXoLpy/6Icq
         FAAKUVCLotwdV3BP2tqmVBRetv4jYYdwyb1xZD1a8VNkUNh37QMwZvS7KWQ/R9wQQr
         vDqTFjWObuBql7UHRgLh6WNgrJsRrQmUrJI2LhEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Assmann <sassmann@kpanic.de>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.15 244/262] iavf: do not override the adapter state in the watchdog task (again)
Date:   Mon,  7 Mar 2022 10:19:48 +0100
Message-Id: <20220307091710.389352962@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

commit fe523d7c9a8332855376ad5eb1aa301091129ba4 upstream.

The watchdog task incorrectly changes the state to __IAVF_RESETTING,
instead of letting the reset task take care of that. This was already
resolved by commit 22c8fd71d3a5 ("iavf: do not override the adapter
state in the watchdog task") but the problem was reintroduced by the
recent code refactoring in commit 45eebd62999d ("iavf: Refactor iavf
state machine tracking").

Fixes: 45eebd62999d ("iavf: Refactor iavf state machine tracking")
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2110,7 +2110,6 @@ static void iavf_watchdog_task(struct wo
 	/* check for hw reset */
 	reg_val = rd32(hw, IAVF_VF_ARQLEN1) & IAVF_VF_ARQLEN1_ARQENABLE_MASK;
 	if (!reg_val) {
-		iavf_change_state(adapter, __IAVF_RESETTING);
 		adapter->flags |= IAVF_FLAG_RESET_PENDING;
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;


