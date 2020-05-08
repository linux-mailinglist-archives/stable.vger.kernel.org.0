Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9271CAFEC
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgEHNVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728654AbgEHMkJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9A1D2496A;
        Fri,  8 May 2020 12:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941608;
        bh=D3MJC+2qPG1IavHeiaYeHNHbRpFemYPUFUrOQDJhJm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zeoI24jafYN4IIz/Hnrq3/8jeIWyXFb2N1dTJJgTcZu4RNfVusBuIgeANg+mTAwDx
         1S0TWK4uGra10Z/3PUZDu2y7j446zcOqWIvsZu6hS//z6jl+pzTXT23PYyZZBq5dBk
         PrEQdQQZUKkuu3utiQAbuXQhXNYvSHNNHTIDKTCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 4.4 063/312] vfio/pci: Allow VPD short read
Date:   Fri,  8 May 2020 14:30:54 +0200
Message-Id: <20200508123128.982023141@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

commit ce7585f3c4d76bca1dff4b66ae1ea32552954f9e upstream.

The size of the VPD area is not necessarily 4-byte aligned, so a
pci_vpd_read() might return less than 4 bytes.  Zero our buffer and
accept anything other than an error.  Intel X710 NICs exercise this.

Fixes: 4e1a635552d3 ("vfio/pci: Use kernel VPD access functions")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vfio/pci/vfio_pci_config.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -698,7 +698,8 @@ static int vfio_vpd_config_write(struct
 		if (pci_write_vpd(pdev, addr & ~PCI_VPD_ADDR_F, 4, &data) != 4)
 			return count;
 	} else {
-		if (pci_read_vpd(pdev, addr, 4, &data) != 4)
+		data = 0;
+		if (pci_read_vpd(pdev, addr, 4, &data) < 0)
 			return count;
 		*pdata = cpu_to_le32(data);
 	}


