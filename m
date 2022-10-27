Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF17760FDE9
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236808AbiJ0RAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236768AbiJ0RAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC6059247
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC463623EC
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED204C433D7;
        Thu, 27 Oct 2022 17:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890017;
        bh=IelhFjdo+Nbb+ZaaSKU7P1Dwd1+KS+fy+R7cjWKzj+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQrKfpxZPcGXq2KYAD09JRTblT1h7RYXwMzvrBeP2q+q2bn77V+LDoQ4lfhF9UhbN
         RD78mhqE/SUaBteuwHSoy6Y2HwUBMaFcmQbQBNOG1s5Ck7yZ5wJfiQ1QDdGCZs3FBx
         Q93N6acrcg68Ab7+TsQ6QVqlkqDdXa9AH0LN+mug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steven Rostedt <rostedt@goodmis.org>,
        kernel test robot <lkp@intel.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 85/94] rv/dot2c: Make automaton definition static
Date:   Thu, 27 Oct 2022 18:55:27 +0200
Message-Id: <20221027165100.615336065@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@kernel.org>

[ Upstream commit 21a1994b6492b12e55dbf39d15271430ef6839f0 ]

Monitor's automata definition is only used locally, so make dot2c generate
a static definition.

Link: https://lore.kernel.org/all/202208210332.gtHXje45-lkp@intel.com
Link: https://lore.kernel.org/all/202208210358.6HH3OrVs-lkp@intel.com
Link: https://lkml.kernel.org/r/ffbb92010f643307766c9307fd42f416e5b85fa0.1661266564.git.bristot@kernel.org

Cc: Steven Rostedt <rostedt@goodmis.org>
Fixes: e3c9fc78f096 ("tools/rv: Add dot2c")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/verification/dot2/dot2c.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/verification/dot2/dot2c.py b/tools/verification/dot2/dot2c.py
index fa73353f7e56..be8a364a469b 100644
--- a/tools/verification/dot2/dot2c.py
+++ b/tools/verification/dot2/dot2c.py
@@ -111,7 +111,7 @@ class Dot2c(Automata):
 
     def format_aut_init_header(self):
         buff = []
-        buff.append("struct %s %s = {" % (self.struct_automaton_def, self.var_automaton_def))
+        buff.append("static struct %s %s = {" % (self.struct_automaton_def, self.var_automaton_def))
         return buff
 
     def __get_string_vector_per_line_content(self, buff):
-- 
2.35.1



