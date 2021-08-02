Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F863DD969
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbhHBOAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:00:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235759AbhHBN5x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:57:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B01DE60F50;
        Mon,  2 Aug 2021 13:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912507;
        bh=kE9Bk9DFA1RgdtiMAimfsy3v2qOuPct73DWDjzSZdYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LiRrI2C0rDTh+iS7HAVdpH2jToYadyo3QUkfQPbY7F0S//M2Kj+19/wEUnocSuBMa
         h6pVzfuscGsTn1ImBOKwd1b5nbrva4F0Q1BUMVQcmG6CBgNBX1QZQbp4rVLU2xKbSS
         DAWXGZuTfF6So1BGLcYxhtj5OWRnIOMgkhRXG8M4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Shannon Nelson <shannon.lee.nelson@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Jakma <paul@jakma.org>
Subject: [PATCH 5.13 024/104] NIU: fix incorrect error return, missed in previous revert
Date:   Mon,  2 Aug 2021 15:44:21 +0200
Message-Id: <20210802134344.814010895@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Jakma <paul@jakma.org>

commit 15bbf8bb4d4ab87108ecf5f4155ec8ffa3c141d6 upstream.

Commit 7930742d6, reverting 26fd962, missed out on reverting an incorrect
change to a return value.  The niu_pci_vpd_scan_props(..) == 1 case appears
to be a normal path - treating it as an error and return -EINVAL was
breaking VPD_SCAN and causing the driver to fail to load.

Fix, so my Neptune card works again.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Shannon Nelson <shannon.lee.nelson@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org>
Fixes: 7930742d ('Revert "niu: fix missing checks of niu_pci_eeprom_read"')
Signed-off-by: Paul Jakma <paul@jakma.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sun/niu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -8191,8 +8191,9 @@ static int niu_pci_vpd_fetch(struct niu
 		err = niu_pci_vpd_scan_props(np, here, end);
 		if (err < 0)
 			return err;
+		/* ret == 1 is not an error */
 		if (err == 1)
-			return -EINVAL;
+			return 0;
 	}
 	return 0;
 }


