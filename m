Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9712766DE1
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbfGLMeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:34:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729326AbfGLMeY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:34:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 385A120645;
        Fri, 12 Jul 2019 12:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934863;
        bh=vUf3XpGa+WekQ5lIiG92xQn8VR8/MuKJgGBSwBLnhYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJ//bFaD6OKUYkxdmOx25xCnm7OY6R0Rd0HXzkgDjegutAvefnFK/xfjxgR34oqXs
         84jTmlmlpqDv8QTtGktwxUsTwPyvSB/9JolkKaf/akDDgWNGywmx/L+5cxa9K/tlCT
         +/CyeTeBh+jKyf3fYo+guPmCO4O+fEqPtLXmi4js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 5.2 56/61] staging: fsl-dpaa2/ethsw: fix memory leak of switchdev_work
Date:   Fri, 12 Jul 2019 14:20:09 +0200
Message-Id: <20190712121623.783638764@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
References: <20190712121620.632595223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 5555ebbbac822b4fa28db2be15aaf98b3c21af26 upstream.

In the default event case switchdev_work is being leaked because
nothing is queued for work. Fix this by kfree'ing switchdev_work
before returning NOTIFY_DONE.

Addresses-Coverity: ("Resource leak")
Fixes: 44baaa43d7cc ("staging: fsl-dpaa2/ethsw: Add Freescale DPAA2 Ethernet Switch driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -1086,6 +1086,7 @@ static int port_switchdev_event(struct n
 		dev_hold(dev);
 		break;
 	default:
+		kfree(switchdev_work);
 		return NOTIFY_DONE;
 	}
 


