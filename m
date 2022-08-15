Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47188594935
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244368AbiHOXLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352822AbiHOXI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:08:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9CDC8708C;
        Mon, 15 Aug 2022 12:59:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92DBEB80EAD;
        Mon, 15 Aug 2022 19:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92BBC433D7;
        Mon, 15 Aug 2022 19:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593589;
        bh=pA8ISevhUsGe/p5+9L1xkYfUhHfjRk8HP8uS3OlHxrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vhDjpzW/7I5qgbLnHapEpnN/MO1OgVH7qUwQeoexwGg8zIT52puU0iqm36WpxYVO9
         +RVYpIztISdBAzL/9oHjCi/42JRDYF0GOUe64kqMWkbiQhJWU5GIaY68499SJ1O7Tg
         irvb6VI7bwoaWyKCvVeundAHmeu/jp7Mw8AehS68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "x86@kernel.org" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.18 0972/1095] ftrace/x86: Add back ftrace_expected assignment
Date:   Mon, 15 Aug 2022 20:06:11 +0200
Message-Id: <20220815180509.279790937@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit ac6c1b2ca77e722a1e5d651f12f437f2f237e658 upstream.

When a ftrace_bug happens (where ftrace fails to modify a location) it is
helpful to have what was at that location as well as what was expected to
be there.

But with the conversion to text_poke() the variable that assigns the
expected for debugging was dropped. Unfortunately, I noticed this when I
needed it. Add it back.

Link: https://lkml.kernel.org/r/20220726101851.069d2e70@gandalf.local.home

Cc: "x86@kernel.org" <x86@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Fixes: 768ae4406a5c ("x86/ftrace: Use text_poke()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/ftrace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -93,6 +93,7 @@ static int ftrace_verify_code(unsigned l
 
 	/* Make sure it is what we expect it to be */
 	if (memcmp(cur_code, old_code, MCOUNT_INSN_SIZE) != 0) {
+		ftrace_expected = old_code;
 		WARN_ON(1);
 		return -EINVAL;
 	}


