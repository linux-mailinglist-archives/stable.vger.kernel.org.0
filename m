Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC24C13A5F3
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbgANKGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:06:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:35956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730412AbgANKGk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:06:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D31524679;
        Tue, 14 Jan 2020 10:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996399;
        bh=bf/93A/tS660991vEZMb8GUK5RE0kZh69l+1eSztkcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yKwAdbEC00/7pcNnR90qh0mI0upe6MuOPR/4TGvyaXEJcIFZWalx5ka6RvNAH81qH
         ZgVEKAX1oMTGE6Cke1onsS+fEwph/EBQszSzgYaW2AixQkh9P7Zd5oOh25+M2yCoIf
         hTGNFZ3OZEwIGmk2WV/uUgdfBJ63J/QHSUVkzOMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 5.4 68/78] rpmsg: char: release allocated memory
Date:   Tue, 14 Jan 2020 11:01:42 +0100
Message-Id: <20200114094402.501506278@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit bbe692e349e2a1edf3fe0a29a0e05899c9c94d51 upstream.

In rpmsg_eptdev_write_iter, if copy_from_iter_full fails the allocated
buffer needs to be released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rpmsg/rpmsg_char.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/rpmsg/rpmsg_char.c
+++ b/drivers/rpmsg/rpmsg_char.c
@@ -227,8 +227,10 @@ static ssize_t rpmsg_eptdev_write_iter(s
 	if (!kbuf)
 		return -ENOMEM;
 
-	if (!copy_from_iter_full(kbuf, len, from))
-		return -EFAULT;
+	if (!copy_from_iter_full(kbuf, len, from)) {
+		ret = -EFAULT;
+		goto free_kbuf;
+	}
 
 	if (mutex_lock_interruptible(&eptdev->ept_lock)) {
 		ret = -ERESTARTSYS;


