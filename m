Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6632E4115
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440158AbgL1ONf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:13:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440210AbgL1ONf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:13:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5A5922C97;
        Mon, 28 Dec 2020 14:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164774;
        bh=YluCWdZM4mCS8hD73LBm0Q/wuzWnO7VOYpz5c2pvBCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTeI73RbaYa0jra69MOjC3u5pWqLov+uBYxhNiiL9rNwXKDCNAcgYwJ1eEg+9+239
         EogAKPoIcZxR9gUKoc89ueP8v1Z80+abQsMB1/WKflC2uajWRAJ5aOI70frXADNGJU
         PGQ2OyzSbYydwWdHS7JOEy7yh++l5ox72SIVcK+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 294/717] scripts: kernel-doc: fix parsing function-like typedefs
Date:   Mon, 28 Dec 2020 13:44:52 +0100
Message-Id: <20201228125035.111957081@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 7d2c6b1edf790d96e9017a0b27be2425e1af1532 ]

Changeset 6b80975c6308 ("scripts: kernel-doc: fix typedef parsing")
added support for things like:

	typedef unsigned long foo();

However, it caused a regression on this prototype:

	typedef bool v4l2_check_dv_timings_fnc(const struct v4l2_dv_timings *t, void *handle);

This is only noticed after adding a patch that checks if the
kernel-doc identifier matches the typedef:

	./scripts/kernel-doc -none $(git grep '^.. kernel-doc::' Documentation/ |cut -d ' ' -f 3|sort|uniq) 2>&1|grep expecting
	include/media/v4l2-dv-timings.h:38: warning: expecting prototype for typedef v4l2_check_dv_timings_fnc. Prototype was for typedef nc instead

The problem is that, with the new parsing logic, it is not
checking for complete words at the type part.

Fix it by adding a \b at the end of each type word at the
regex.

fixes: 6b80975c6308 ("scripts: kernel-doc: fix typedef parsing")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Link: https://lore.kernel.org/r/218ff56dcb8e73755005d3fb64586eb1841a276b.1606896997.git.mchehab+huawei@kernel.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kernel-doc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 9b6ddeb097e93..6325bec3f66f8 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1431,7 +1431,7 @@ sub dump_enum($$) {
     }
 }
 
-my $typedef_type = qr { ((?:\s+[\w\*]+){1,8})\s* }x;
+my $typedef_type = qr { ((?:\s+[\w\*]+\b){1,8})\s* }x;
 my $typedef_ident = qr { \*?\s*(\w\S+)\s* }x;
 my $typedef_args = qr { \s*\((.*)\); }x;
 
-- 
2.27.0



