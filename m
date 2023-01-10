Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320A36648B4
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239299AbjAJSOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239048AbjAJSNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:13:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5410E30579
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:11:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7F03B81903
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FD0C433F0;
        Tue, 10 Jan 2023 18:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374303;
        bh=wIJKBYaQ1VXqSBSFwrxCbb9ti8ZKJ7yZl0stDP+aba8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yivMUO5FqPfr89DqNsA3dVnQ9zu1qrOezBX7rRIMcIhmKlOllP61UmwQ0M4deW29H
         /f6VAagIy/y/i+ghIYLH4h7O7ruQwBJ/0e/s9VFLiXcqOe5l+CHoHbKJcPdRf7rwKG
         gDzSEX7xvJazNTad2bZ2YYTMyjAelaByc1fFGb3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rodrigo Branco <bsdaemon@google.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.0 122/148] x86/bugs: Flush IBP in ib_prctl_set()
Date:   Tue, 10 Jan 2023 19:03:46 +0100
Message-Id: <20230110180021.062132400@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Branco <bsdaemon@google.com>

commit a664ec9158eeddd75121d39c9a0758016097fa96 upstream.

We missed the window between the TIF flag update and the next reschedule.

Signed-off-by: Rodrigo Branco <bsdaemon@google.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1951,6 +1951,8 @@ static int ib_prctl_set(struct task_stru
 		if (ctrl == PR_SPEC_FORCE_DISABLE)
 			task_set_spec_ib_force_disable(task);
 		task_update_spec_tif(task);
+		if (task == current)
+			indirect_branch_prediction_barrier();
 		break;
 	default:
 		return -ERANGE;


