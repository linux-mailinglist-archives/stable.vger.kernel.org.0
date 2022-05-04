Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE88551A9DB
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357691AbiEDRTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358256AbiEDRPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA8956755;
        Wed,  4 May 2022 09:59:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6303E618D7;
        Wed,  4 May 2022 16:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF92CC385B7;
        Wed,  4 May 2022 16:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683547;
        bh=jqiIuEIrnPH+mxbYqx0dJSBw+ip8rOGrsXRlAQce6w8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VL0u53Kxj0kfYbrxsX7WwzCzKi5V+JkxGblEViBS+RY2sKp8mC+QRAIyODjg3zx8C
         qbKoJFz2RjWsFBWiu3+tVzJSQhi7R8JoTBR4cicjMrtEUX29sK8r9zT1Bc3e2XQBta
         owM9s/wywPVaRzz4jTKW6aodGm5p22Oig5m/SbTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.17 201/225] tty: n_gsm: fix missing mux reset on config change at responder
Date:   Wed,  4 May 2022 18:47:19 +0200
Message-Id: <20220504153128.101130820@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Starke <daniel.starke@siemens.com>

commit 11451693e4081d32ef65147c6ca08cd0094ae252 upstream.

Currently, only the initiator resets the mux protocol if the user requests
new parameters that are incompatible to those of the current connection.
The responder also needs to reset the multiplexer if the new parameter set
requires this. Otherwise, we end up with an inconsistent parameter set
between initiator and responder.
Revert the old behavior to inform the peer upon an incompatible parameter
set change from the user on the responder side by re-establishing the mux
protocol in such case.

Fixes: 509067bbd264 ("tty: n_gsm: Delete gsm_disconnect when config requester")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220414094225.4527-1-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2373,7 +2373,7 @@ static int gsm_config(struct gsm_mux *gs
 	 * configuration
 	 */
 
-	if (gsm->initiator && (need_close || need_restart)) {
+	if (need_close || need_restart) {
 		int ret;
 
 		ret = gsm_disconnect(gsm);


