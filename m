Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1536C328719
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236277AbhCARTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:19:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:48196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237781AbhCARNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:13:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 879786502E;
        Mon,  1 Mar 2021 16:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617049;
        bh=ORPCG6lNXDbkMXeS/l0DdB+Se3UxgSZObZMpSEonDEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JwV1XQCy7seugTA3jj6C4mlIhmzJR9+ge4r5Eu6rJFLuYklDVkinFOz9Tt/5Fzm0A
         jmrq5BKHQiBLnuYbYlgLLUCNELtFomA2zYEn0oQgyDJpoJISocMO0y6nu4cN80pd5T
         ZBspRezGwEdLxm0KPHb/nfdb2gG9j1yEyDAivKDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 184/247] Input: joydev - prevent potential read overflow in ioctl
Date:   Mon,  1 Mar 2021 17:13:24 +0100
Message-Id: <20210301161040.665826495@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 182d679b2298d62bf42bb14b12a8067b8e17b617 upstream.

The problem here is that "len" might be less than "joydev->nabs" so the
loops which verfy abspam[i] and keypam[] might read beyond the buffer.

Fixes: 999b874f4aa3 ("Input: joydev - validate axis/button maps before clobbering current ones")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YCyzR8WvFRw4HWw6@mwanda
[dtor: additional check for len being even in joydev_handle_JSIOCSBTNMAP]
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joydev.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -460,7 +460,7 @@ static int joydev_handle_JSIOCSAXMAP(str
 	if (IS_ERR(abspam))
 		return PTR_ERR(abspam);
 
-	for (i = 0; i < joydev->nabs; i++) {
+	for (i = 0; i < len && i < joydev->nabs; i++) {
 		if (abspam[i] > ABS_MAX) {
 			retval = -EINVAL;
 			goto out;
@@ -484,6 +484,9 @@ static int joydev_handle_JSIOCSBTNMAP(st
 	int i;
 	int retval = 0;
 
+	if (len % sizeof(*keypam))
+		return -EINVAL;
+
 	len = min(len, sizeof(joydev->keypam));
 
 	/* Validate the map. */
@@ -491,7 +494,7 @@ static int joydev_handle_JSIOCSBTNMAP(st
 	if (IS_ERR(keypam))
 		return PTR_ERR(keypam);
 
-	for (i = 0; i < joydev->nkey; i++) {
+	for (i = 0; i < (len / 2) && i < joydev->nkey; i++) {
 		if (keypam[i] > KEY_MAX || keypam[i] < BTN_MISC) {
 			retval = -EINVAL;
 			goto out;


