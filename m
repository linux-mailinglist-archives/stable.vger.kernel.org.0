Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50357353D76
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237105AbhDEI76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:59:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236524AbhDEI7z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:59:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1B43613B0;
        Mon,  5 Apr 2021 08:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613189;
        bh=dB2GI0K51dN1Sl0JccgDDEk+G5HBCHCUHclBpalLCxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XrR8b78km1Y74qoJxYqW1dAYvpZ64f6jhe9I8QbAolceEPOhGy4ll53msUqH5OWWx
         Q1f66jElCe6M9e2oHWlSoQv/590D5CyhR+dFlQfuNNCh98PbdrRgsKnckPSQDFnnth
         tyLZh/cJZ6hrosg+0jm6kP5uIbKkrnqwV4qNIczs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b67aaae8d3a927f68d20@syzkaller.appspotmail.com,
        Du Cheng <ducheng2@gmail.com>
Subject: [PATCH 4.14 52/52] drivers: video: fbcon: fix NULL dereference in fbcon_cursor()
Date:   Mon,  5 Apr 2021 10:54:18 +0200
Message-Id: <20210405085023.681659437@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085021.996963957@linuxfoundation.org>
References: <20210405085021.996963957@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Du Cheng <ducheng2@gmail.com>

commit 01faae5193d6190b7b3aa93dae43f514e866d652 upstream.

add null-check on function pointer before dereference on ops->cursor

Reported-by: syzbot+b67aaae8d3a927f68d20@syzkaller.appspotmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Du Cheng <ducheng2@gmail.com>
Link: https://lore.kernel.org/r/20210312081421.452405-1-ducheng2@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1284,6 +1284,9 @@ static void fbcon_cursor(struct vc_data
 
 	ops->cursor_flash = (mode == CM_ERASE) ? 0 : 1;
 
+	if (!ops->cursor)
+		return;
+
 	ops->cursor(vc, info, mode, get_color(vc, info, c, 1),
 		    get_color(vc, info, c, 0));
 }


