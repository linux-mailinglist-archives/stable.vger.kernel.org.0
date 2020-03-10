Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 326BD17FE37
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbgCJMrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbgCJMrW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:47:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D42E62468D;
        Tue, 10 Mar 2020 12:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844442;
        bh=gQWh7sVvH+z0XgXF4BmUO0G1rkaaDUhYsderlOQ/u0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ig/UmTMVyKGRg/eFYPonRNWIvXrDR1PzGrD/yp9QOvNOyvH3au2/F/eOPIanmL2M4
         vbhSmQHHmB3OGoYIwgU9Mxz+WJuKj+LbRESSJU5w08vdf/LunXZZsY73GQ3MSnQtOO
         O0IXfc/CFkO9Z/vkxojcG4RurYG9xkQEiXdyG/SU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.9 84/88] hwmon: (adt7462) Fix an error return in ADT7462_REG_VOLT()
Date:   Tue, 10 Mar 2020 13:39:32 +0100
Message-Id: <20200310123624.933829480@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123606.543939933@linuxfoundation.org>
References: <20200310123606.543939933@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 44f2f882909fedfc3a56e4b90026910456019743 upstream.

This is only called from adt7462_update_device().  The caller expects it
to return zero on error.  I fixed a similar issue earlier in commit
a4bf06d58f21 ("hwmon: (adt7462) ADT7462_REG_VOLT_MAX() should return 0")
but I missed this one.

Fixes: c0b4e3ab0c76 ("adt7462: new hwmon driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Link: https://lore.kernel.org/r/20200303101608.kqjwfcazu2ylhi2a@kili.mountain
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/adt7462.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/adt7462.c
+++ b/drivers/hwmon/adt7462.c
@@ -426,7 +426,7 @@ static int ADT7462_REG_VOLT(struct adt74
 			return 0x95;
 		break;
 	}
-	return -ENODEV;
+	return 0;
 }
 
 /* Provide labels for sysfs */


