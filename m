Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F944F3A4E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379163AbiDELk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354390AbiDEKOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:14:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C6A6A00A;
        Tue,  5 Apr 2022 02:59:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62F70B818F6;
        Tue,  5 Apr 2022 09:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B095EC385A2;
        Tue,  5 Apr 2022 09:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152778;
        bh=UW7sADSpeZ8uaQdmEsxtEglXjUGyuz+vRPdBIfA1Nvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A9kNk8AaJDnYXyYx03R0P1kW/0yFqroD5kK9hqaGGKsFrInEOi0WIqoJmIe2F0xgN
         jL4B0LsxT0lf+8FW/1zkj0y3Tr2tVyJ9VvYFi7+VAISrmkkogNL2rQZW03IYDN1zds
         k4COxSTzRwuNTt9vj2vtDuYD4WaaZmZsHBHy5mc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Feng Tang <feng.tang@intel.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 898/913] docs: sysctl/kernel: add missing bit to panic_print
Date:   Tue,  5 Apr 2022 09:32:40 +0200
Message-Id: <20220405070406.737762271@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Guilherme G. Piccoli <gpiccoli@igalia.com>

commit a1ff1de00db21ecb956213f046b79741b64c6b65 upstream.

Patch series "Some improvements on panic_print".

This is a mix of a documentation fix with some additions to the
"panic_print" syscall / parameter.  The goal here is being able to collect
all CPUs backtraces during a panic event and also to enable "panic_print"
in a kdump event - details of the reasoning and design choices in the
patches.

This patch (of 3):

Commit de6da1e8bcf0 ("panic: add an option to replay all the printk
message in buffer") added a new bit to the sysctl/kernel parameter
"panic_print", but the documentation was added only in
kernel-parameters.txt, not in the sysctl guide.

Fix it here by adding bit 5 to sysctl admin-guide documentation.

[rdunlap@infradead.org: fix table format warning]
  Link: https://lkml.kernel.org/r/20220109055635.6999-1-rdunlap@infradead.org

Link: https://lkml.kernel.org/r/20211109202848.610874-1-gpiccoli@igalia.com
Link: https://lkml.kernel.org/r/20211109202848.610874-2-gpiccoli@igalia.com
Fixes: de6da1e8bcf0 ("panic: add an option to replay all the printk message in buffer")
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Reviewed-by: Feng Tang <feng.tang@intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/sysctl/kernel.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -795,6 +795,7 @@ bit 1  print system memory info
 bit 2  print timer info
 bit 3  print locks info if ``CONFIG_LOCKDEP`` is on
 bit 4  print ftrace buffer
+bit 5  print all printk messages in buffer
 =====  ============================================
 
 So for example to print tasks and memory info on panic, user can::


