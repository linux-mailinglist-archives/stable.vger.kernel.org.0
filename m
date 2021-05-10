Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D5737854F
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235103AbhEJLAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234099AbhEJKzw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:55:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8D6B61627;
        Mon, 10 May 2021 10:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643426;
        bh=blTBK4coGOXJdU/M+D/vhYWK2BaNbcJiqs0sXBYGoYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RzKk1zGPZEUcfzk1CAUHWaRX4UvqmMV+OkD9vO5ChDn53ZR0xTIgPKSgi9j2SV085
         xSWBAaLr13PZxdwnV25wMBmviZihO9Uv4pQlDwmGfQJaR3fz/CAYxLe/4iwg7wMFu3
         x9Akt1WyW3DC08Vd4OAuty7GXSuBIWhM+idabvzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.11 011/342] s390/cio: remove invalid condition on IO_SCH_UNREG
Date:   Mon, 10 May 2021 12:16:41 +0200
Message-Id: <20210510102010.480865544@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineeth Vijayan <vneethv@linux.ibm.com>

commit 2f7484fd73729f89085fe08d683f5a8d9e17fe99 upstream.

The condition to check the cdev pointer validity on
css_sch_device_unregister() is a leftover from the 'commit 8cc0dcfdc1c0
("s390/cio: remove pm support from ccw bus driver")'. This could lead to a
situation, where detaching the device is not happening completely. Remove
this invalid condition in the IO_SCH_UNREG case.

Link: https://lore.kernel.org/r/20210423100843.2230969-1-vneethv@linux.ibm.com
Fixes: 8cc0dcfdc1c0 ("s390/cio: remove pm support from ccw bus driver")
Reported-by: Christian Ehrhardt <christian.ehrhardt@canonical.com>
Suggested-by: Christian Ehrhardt <christian.ehrhardt@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Tested-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Tested-by: Christian Ehrhardt <christian.ehrhardt@canonical.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/device.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1525,8 +1525,7 @@ static int io_subchannel_sch_event(struc
 	switch (action) {
 	case IO_SCH_ORPH_UNREG:
 	case IO_SCH_UNREG:
-		if (!cdev)
-			css_sch_device_unregister(sch);
+		css_sch_device_unregister(sch);
 		break;
 	case IO_SCH_ORPH_ATTACH:
 	case IO_SCH_UNREG_ATTACH:


