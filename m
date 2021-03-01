Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E0E3286A3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237678AbhCARNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:13:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:36106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236783AbhCARHG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:07:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0010564F79;
        Mon,  1 Mar 2021 16:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616837;
        bh=s//kz97nON8nvzw4MNeeNZmq/9waPmgrwHCSQPCHk1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3O0JBEpC3k/J+eyXLidP87PC+6x9vJaUsMB8ywTC/Z13+SnuCnTsPwFdTiQcUisg
         9Du1hNI4yhrXRta4JeWTQHQ832KiBsDjlRl0Ztv69GkL/pcVZey6e5nRKnOit9bgQv
         eKGEoUkE63wBlEMEr1EMcULs/3G3A1Ifh/1Q2QWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        syzbot+1e911ad71dd4ea72e04a@syzkaller.appspotmail.com,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 112/247] HID: core: detect and skip invalid inputs to snto32()
Date:   Mon,  1 Mar 2021 17:12:12 +0100
Message-Id: <20210301161037.154110947@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit a0312af1f94d13800e63a7d0a66e563582e39aec ]

Prevent invalid (0, 0) inputs to hid-core's snto32() function.

Maybe it is just the dummy device here that is causing this, but
there are hundreds of calls to snto32(0, 0). Having n (bits count)
of 0 is causing the current UBSAN trap with a shift value of
0xffffffff (-1, or n - 1 in this function).

Either of the value to shift being 0 or the bits count being 0 can be
handled by just returning 0 to the caller, avoiding the following
complex shift + OR operations:

	return value & (1 << (n - 1)) ? value | (~0U << n) : value;

Fixes: dde5845a529f ("[PATCH] Generic HID layer - code split")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: syzbot+1e911ad71dd4ea72e04a@syzkaller.appspotmail.com
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: linux-input@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index bde5cef3290f5..9b66eb1d42c2d 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1128,6 +1128,9 @@ EXPORT_SYMBOL_GPL(hid_open_report);
 
 static s32 snto32(__u32 value, unsigned n)
 {
+	if (!value || !n)
+		return 0;
+
 	switch (n) {
 	case 8:  return ((__s8)value);
 	case 16: return ((__s16)value);
-- 
2.27.0



