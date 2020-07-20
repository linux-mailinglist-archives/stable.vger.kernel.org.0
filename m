Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8AA32263D0
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbgGTPko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729758AbgGTPko (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:40:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31BCF20773;
        Mon, 20 Jul 2020 15:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259643;
        bh=Gnn04dSXI7aMIFI6xFMx15OTYSb1EJtcg0QvAL//x2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yn0eKg7w6gsypyPEaIhN3RPwPSgfekkr31Jz+h9Yg5qmbBgGLpglGTaYq+MNt0we/
         5epo17i4vuYzbelgZHwgw/YkoSpInoTIe0935FD7TfR8/QlBziSssH2DIG3KH7Uctb
         vCBVLWEfW74O7vAZKNbO1qWIx8MZ9d93m3AnVDF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 4.9 26/86] s390/mm: fix huge pte soft dirty copying
Date:   Mon, 20 Jul 2020 17:36:22 +0200
Message-Id: <20200720152754.467193788@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
References: <20200720152753.138974850@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

commit 528a9539348a0234375dfaa1ca5dbbb2f8f8e8d2 upstream.

If the pmd is soft dirty we must mark the pte as soft dirty (and not dirty).
This fixes some cases for guest migration with huge page backings.

Cc: <stable@vger.kernel.org> # 4.8
Fixes: bc29b7ac1d9f ("s390/mm: clean up pte/pmd encoding")
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/mm/hugetlbpage.c
+++ b/arch/s390/mm/hugetlbpage.c
@@ -111,7 +111,7 @@ static inline pte_t __rste_to_pte(unsign
 					     _PAGE_YOUNG);
 #ifdef CONFIG_MEM_SOFT_DIRTY
 		pte_val(pte) |= move_set_bit(rste, _SEGMENT_ENTRY_SOFT_DIRTY,
-					     _PAGE_DIRTY);
+					     _PAGE_SOFT_DIRTY);
 #endif
 	} else
 		pte_val(pte) = _PAGE_INVALID;


