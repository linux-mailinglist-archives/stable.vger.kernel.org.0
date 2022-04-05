Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4594F27BF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbiDEIIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235677AbiDEIAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:00:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C072193F1;
        Tue,  5 Apr 2022 00:57:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCD6C61668;
        Tue,  5 Apr 2022 07:57:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2148C340EE;
        Tue,  5 Apr 2022 07:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145463;
        bh=iRMLrCcmHK2o0zFZt5G8QCNBCZd5OLcLajl8zPkZ1nU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+Q0eFR5CHjpBlThgkVMPqN1HKVYZf6XV3mtgRjnQ3drT4sET1q+YWm7PqqqzxmSF
         SUIzb+qI3778vIWRfJ8or+lT3uGdMaS1DMMXKynXGd3KZORjToaB4WtVwduu8xF2AW
         saFFwJRjuWhmyiicykWoKU45k/3k7QJU7i64PO4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Clark Williams <williams@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0413/1126] rtla/osnoise: Fix osnoise hist stop tracing message
Date:   Tue,  5 Apr 2022 09:19:20 +0200
Message-Id: <20220405070419.748490721@linuxfoundation.org>
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

From: Daniel Bristot de Oliveira <bristot@kernel.org>

[ Upstream commit 7d38c35167c58153e8b5bea839616d00e90564b9 ]

rtla osnoise hist is printing the following message when hitting stop
tracing:

  printf("rtla timelat hit stop tracing\n");

which is obviosly wrong.

s/timerlat/osnoise/ fixing the printf.

Link: https://lkml.kernel.org/r/2b8f090556fe37b81d183b74ce271421f131c77b.1646247211.git.bristot@kernel.org

Fixes: 829a6c0b5698 ("rtla/osnoise: Add the hist mode")
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Clark Williams <williams@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/osnoise_hist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/src/osnoise_hist.c b/tools/tracing/rtla/src/osnoise_hist.c
index 52c053cc1789..e88f5c870141 100644
--- a/tools/tracing/rtla/src/osnoise_hist.c
+++ b/tools/tracing/rtla/src/osnoise_hist.c
@@ -782,7 +782,7 @@ int osnoise_hist_main(int argc, char *argv[])
 	return_value = 0;
 
 	if (!tracefs_trace_is_on(trace->inst)) {
-		printf("rtla timelat hit stop tracing\n");
+		printf("rtla osnoise hit stop tracing\n");
 		if (params->trace_output) {
 			printf("  Saving trace to %s\n", params->trace_output);
 			save_trace_to_file(record->trace.inst, params->trace_output);
-- 
2.34.1



