Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA641FBAF2
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731465AbgFPPld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730575AbgFPPld (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:41:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F631208E4;
        Tue, 16 Jun 2020 15:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322092;
        bh=d97WpFy+5OREEuxVaheOyuxtpt3chE+sXqbZmAI3iho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SctYqyZ3sqWsg1If4Z1gnMOJRfC/ZKNYKRS+8cROMMn0TdKwnXrET33o0C5415HPg
         UDS5QaBYHjV6fI4+alEP8DAH5BlNYUPAxu9WdbUmJrDY+XUUC8rD5EXXJtk+nJnWyX
         XR8wF2JRZSDCW6WUUXuH6iRblZcp1PqUtGnooIKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 5.4 132/134] xen/pvcalls-back: test for errors when calling backend_connect()
Date:   Tue, 16 Jun 2020 17:35:16 +0200
Message-Id: <20200616153107.109738183@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
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
@@ -1087,7 +1087,8 @@ static void set_backend_state(struct xen
 		case XenbusStateInitialised:
 			switch (state) {
 			case XenbusStateConnected:
-				backend_connect(dev);
+				if (backend_connect(dev))
+					return;
 				xenbus_switch_state(dev, XenbusStateConnected);
 				break;
 			case XenbusStateClosing:


