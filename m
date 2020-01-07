Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99B2C133155
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbgAGU7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:59:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728183AbgAGU7n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:59:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B38B92087F;
        Tue,  7 Jan 2020 20:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430783;
        bh=F6tGxNJCT5nA0qQtWVbRfcpU9HYNtp2tw3U7qotbFXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5gKCdAvHyJ1I4WL9nEtNr6vKnd1cMEuBKS11rH8MUILa8EioaFS2gyScxhHAw1KA
         koL/KDeaJi8Lm3hEk7irYrmGp9D1I2CilwsmLl2fmjwzmpHsmk4ioVF32SOrfnGGSu
         yAH2OlG/2m9q1oxHzO9tI4fnBkDImhxHd0SZ7a84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Tycho Andersen <tycho@tycho.ws>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.4 095/191] samples/seccomp: Zero out members based on seccomp_notif_sizes
Date:   Tue,  7 Jan 2020 21:53:35 +0100
Message-Id: <20200107205338.077706994@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sargun Dhillon <sargun@sargun.me>

commit 771b894f2f3dfedc2ba5561731fffa0e39b1bbb6 upstream.

The sizes by which seccomp_notif and seccomp_notif_resp are allocated are
based on the SECCOMP_GET_NOTIF_SIZES ioctl. This allows for graceful
extension of these datastructures. If userspace zeroes out the
datastructure based on its version, and it is lagging behind the kernel's
version, it will end up sending trailing garbage. On the other hand,
if it is ahead of the kernel version, it will write extra zero space,
and potentially cause corruption.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Suggested-by: Tycho Andersen <tycho@tycho.ws>
Link: https://lore.kernel.org/r/20191230203503.4925-1-sargun@sargun.me
Fixes: fec7b6690541 ("samples: add an example of seccomp user trap")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 samples/seccomp/user-trap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/samples/seccomp/user-trap.c
+++ b/samples/seccomp/user-trap.c
@@ -298,14 +298,14 @@ int main(void)
 		req = malloc(sizes.seccomp_notif);
 		if (!req)
 			goto out_close;
-		memset(req, 0, sizeof(*req));
 
 		resp = malloc(sizes.seccomp_notif_resp);
 		if (!resp)
 			goto out_req;
-		memset(resp, 0, sizeof(*resp));
+		memset(resp, 0, sizes.seccomp_notif_resp);
 
 		while (1) {
+			memset(req, 0, sizes.seccomp_notif);
 			if (ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, req)) {
 				perror("ioctl recv");
 				goto out_resp;


