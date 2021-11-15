Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440184526BF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346467AbhKPCKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:10:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:40732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239167AbhKOR7Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:59:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F6D963334;
        Mon, 15 Nov 2021 17:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997758;
        bh=zp87uNuprfxC2uMwwaLwkybwsctr0woIcDVWlUky9wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hyE4ew0cY5su+crO3ahknqwZOAKrPKiJg3BoN5pVg+yd4qALDC9sKsUzXdkVxtCzf
         tShRE5zQ4EYs23Unix8Vzj86Obn142Eb7zgcbUM8YHDQg7RK4ENTQMGlhpiJ+d07NJ
         wePGwPPEpS9OYh4jBXcIE91StGyivtJo/4HFDsbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 265/575] objtool: Add xen_start_kernel() to noreturn list
Date:   Mon, 15 Nov 2021 17:59:50 +0100
Message-Id: <20211115165352.937085889@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit c26acfbbfbc2ae4167e33825793e85e1a53058d8 ]

xen_start_kernel() doesn't return.  Annotate it as such so objtool can
follow the code flow.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/930deafa89256c60b180442df59a1bbae48f30ab.1611263462.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 5c83f73ad6687..ec15cadbb3d3e 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -156,6 +156,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"machine_real_restart",
 		"rewind_stack_do_exit",
 		"kunit_try_catch_throw",
+		"xen_start_kernel",
 	};
 
 	if (!func)
-- 
2.33.0



