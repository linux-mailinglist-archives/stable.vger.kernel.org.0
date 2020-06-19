Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DCB200C9B
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389030AbgFSOr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:47:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389024AbgFSOr6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:47:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B765217BA;
        Fri, 19 Jun 2020 14:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578078;
        bh=tiCrtYAbKQC9fIQoevdXLhBjypRGfWewBktZLqo92so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fiNaSXyaTfybZftkjSTZehVKwj9M2r6iHDeuaoRX1nvOVxROnb9IlM10WjBzG5Tbx
         THIi7ubgpRDM7JrUcOjctdD80DbX4ZmLnadIqsLUL3UzSXBdP0TrQzBkITvS7MTIL4
         YUYW9cwyHEB1V+iTdYZTAjfQbog9Fe/9C6yb6aSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 4.14 074/190] xen/pvcalls-back: test for errors when calling backend_connect()
Date:   Fri, 19 Jun 2020 16:31:59 +0200
Message-Id: <20200619141637.288886018@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit c8d70a29d6bbc956013f3401f92a4431a9385a3c upstream.

backend_connect() can fail, so switch the device to connected only if
no error occurred.

Fixes: 0a9c75c2c7258f2 ("xen/pvcalls: xenbus state handling")
Cc: stable@vger.kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20200511074231.19794-1-jgross@suse.com
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/pvcalls-back.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/xen/pvcalls-back.c
+++ b/drivers/xen/pvcalls-back.c
@@ -1104,7 +1104,8 @@ static void set_backend_state(struct xen
 		case XenbusStateInitialised:
 			switch (state) {
 			case XenbusStateConnected:
-				backend_connect(dev);
+				if (backend_connect(dev))
+					return;
 				xenbus_switch_state(dev, XenbusStateConnected);
 				break;
 			case XenbusStateClosing:


