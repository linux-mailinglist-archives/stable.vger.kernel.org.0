Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64D84F3426
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbiDEI7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236588AbiDEIlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:41:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEBBAE70;
        Tue,  5 Apr 2022 01:33:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AA45609D0;
        Tue,  5 Apr 2022 08:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56096C385A1;
        Tue,  5 Apr 2022 08:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147624;
        bh=AIwGneCgQREljoh3n2S10EY9Q3wkZzrK2N0v2FayM6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VvKrbTE7t3CBNOFYSKc0hh2vwpVjTjM12bSud2p1/A3kc5vPPuEnL3yi6hKhZRWZJ
         R/JYj8ADtLZr/GNHdBZvyLz5b/g9oVgtqPntK0HC8xBG+Kbrv4jU/8tHOwwjv06+kc
         5LYKnY6qSH9pKIpm6pZQDqw5ziOs0m8OGpZrYhNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ang Tien Sung <tien.sung.ang@intel.com>,
        Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.16 0062/1017] firmware: stratix10-svc: add missing callback parameter on RSU
Date:   Tue,  5 Apr 2022 09:16:15 +0200
Message-Id: <20220405070356.026249360@linuxfoundation.org>
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

From: Ang Tien Sung <tien.sung.ang@intel.com>

commit b850b7a8b369322adf699ef48ceff4d902525c8c upstream.

Fix a bug whereby, the return response of parameter a1 from an
SMC call is not properly set to the callback data during an
INTEL_SIP_SMC_RSU_ERROR command.

Link: https://lore.kernel.org/lkml/20220216081513.28319-1-tien.sung.ang@intel.com
Fixes: 6b50d882d38d ("firmware: add remote status update client support")
Cc: stable@vger.kernel.org
Signed-off-by: Ang Tien Sung <tien.sung.ang@intel.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lore.kernel.org/r/20220223144146.399263-1-dinguyen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/stratix10-svc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -477,7 +477,7 @@ static int svc_normal_to_secure_thread(v
 		case INTEL_SIP_SMC_RSU_ERROR:
 			pr_err("%s: STATUS_ERROR\n", __func__);
 			cbdata->status = BIT(SVC_STATUS_ERROR);
-			cbdata->kaddr1 = NULL;
+			cbdata->kaddr1 = &res.a1;
 			cbdata->kaddr2 = NULL;
 			cbdata->kaddr3 = NULL;
 			pdata->chan->scl->receive_cb(pdata->chan->scl, cbdata);


