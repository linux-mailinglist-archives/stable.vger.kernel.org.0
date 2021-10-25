Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B4243A342
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238530AbhJYT5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:57:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239371AbhJYTzm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:55:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45AB76126A;
        Mon, 25 Oct 2021 19:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191169;
        bh=GEHB12wv7QSflAiMMPhRjWg9aLVBl4txU+NcJisixL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnbtag2sM/b2Way4qYaVyGbgcjrsUT/LpEJ1MVyMwXFycbjhSe0Bp7a+q9K1ek0X8
         FIxkOtLvbSg2G4w54PNcfkzh5dYumCZ51IxuZqEAZpfkPMvRsObUfliySqhGkMEKlS
         9a+bhMIxKrJo3dfvR6ViJAI7sxwBEuA+q6iByTBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.14 162/169] s390/pci: cleanup resources only if necessary
Date:   Mon, 25 Oct 2021 21:15:43 +0200
Message-Id: <20211025191037.965458289@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 02368b7cf6c7badefa13741aed7a8b91d9a11b19 upstream.

It's currently safe to call zpci_cleanup_bus_resources() even if the
resources were never created but it makes no sense so check
zdev->has_resources before we call zpci_cleanup_bus_resources() in
zpci_release_device().

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Acked-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -829,7 +829,8 @@ void zpci_release_device(struct kref *kr
 	case ZPCI_FN_STATE_STANDBY:
 		if (zdev->has_hp_slot)
 			zpci_exit_slot(zdev);
-		zpci_cleanup_bus_resources(zdev);
+		if (zdev->has_resources)
+			zpci_cleanup_bus_resources(zdev);
 		zpci_bus_device_unregister(zdev);
 		zpci_destroy_iommu(zdev);
 		fallthrough;


