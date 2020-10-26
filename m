Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8F029A0CB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408977AbgJZXuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408796AbgJZXts (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:49:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87AC9222D9;
        Mon, 26 Oct 2020 23:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756188;
        bh=W2bEeiQAfoQioyqsnBUOJWlPraJVYRnpniBcf1u+A3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVxJQetIutCf6pWSF4NWuYMWmcHldexAM1Q0djcfge4o1TRc9LaMhg9g2kQgGjEBZ
         K2/Mjt6MGpCAdiohMYKePXUtNxL/xum794pfFH7Etjnc4GMXWE6sYg2MapDDcrlnYc
         FdXthSkmLZE/JU5R9q8tl54HFeTo7l49ARaVmOsc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tom Rix <trix@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.9 034/147] video: fbdev: pvr2fb: initialize variables
Date:   Mon, 26 Oct 2020 19:47:12 -0400
Message-Id: <20201026234905.1022767-34-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 8e1ba47c60bcd325fdd097cd76054639155e5d2e ]

clang static analysis reports this repesentative error

pvr2fb.c:1049:2: warning: 1st function call argument
  is an uninitialized value [core.CallAndMessage]
        if (*cable_arg)
        ^~~~~~~~~~~~~~~

Problem is that cable_arg depends on the input loop to
set the cable_arg[0].  If it does not, then some random
value from the stack is used.

A similar problem exists for output_arg.

So initialize cable_arg and output_arg.

Signed-off-by: Tom Rix <trix@redhat.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200720191845.20115-1-trix@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/pvr2fb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/pvr2fb.c b/drivers/video/fbdev/pvr2fb.c
index 2d9f69b93392a..f4add36cb5f4d 100644
--- a/drivers/video/fbdev/pvr2fb.c
+++ b/drivers/video/fbdev/pvr2fb.c
@@ -1028,6 +1028,8 @@ static int __init pvr2fb_setup(char *options)
 	if (!options || !*options)
 		return 0;
 
+	cable_arg[0] = output_arg[0] = 0;
+
 	while ((this_opt = strsep(&options, ","))) {
 		if (!*this_opt)
 			continue;
-- 
2.25.1

