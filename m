Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26FEC6AE948
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbjCGRWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjCGRWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:22:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD84B901D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:17:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62F70B819AD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDD9C4339B;
        Tue,  7 Mar 2023 17:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209457;
        bh=4v7exfyUa3oXfnZBBCYrlUFcD/YjWSf3Wx1LAxiJObE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YEXtP0cmL2wyE1yiNNAAi32AXv6Hsvyeiu8OskUS6MJKezlb6G0yXsEoNkhb6hbqo
         TMfhxOZMBVh2IcXZx+e5HPXFXkyb1kUHKqhi3MtJDDVu+WV5Q5Xuvu2lLsfrS70yDd
         5hJCAw2GJZob/COR20wrYNdB+u3isJCvDzzYaKjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0195/1001] x86/signal: Fix the value returned by strict_sas_size()
Date:   Tue,  7 Mar 2023 17:49:27 +0100
Message-Id: <20230307170030.361450849@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ef6dfc4b238a435ab552207ec09e4a82b6426d31 ]

Functions used with __setup() return 1 when the argument has been
successfully parsed.

Reverse the returned value so that 1 is returned when kstrtobool() is
successful (i.e. returns 0).

My understanding of these __setup() functions is that returning 1 or 0
does not change much anyway - so this is more of a cleanup than a
functional fix.

I spot it and found it spurious while looking at something else.
Even if the output is not perfect, you'll get the idea with:

   $ git grep -B2 -A10 retu.*kstrtobool | grep __setup -B10

Fixes: 3aac3ebea08f ("x86/signal: Implement sigaltstack size validation")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/73882d43ebe420c9d8fb82d0560021722b243000.1673717552.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 1504eb8d25aa6..004cb30b74198 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -360,7 +360,7 @@ static bool strict_sigaltstack_size __ro_after_init = false;
 
 static int __init strict_sas_size(char *arg)
 {
-	return kstrtobool(arg, &strict_sigaltstack_size);
+	return kstrtobool(arg, &strict_sigaltstack_size) == 0;
 }
 __setup("strict_sas_size", strict_sas_size);
 
-- 
2.39.2



