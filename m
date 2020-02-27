Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3D5171EA9
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387884AbgB0OGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:06:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:43120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387881AbgB0OGG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:06:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C79820578;
        Thu, 27 Feb 2020 14:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812365;
        bh=01jRytznLKB9NL/cMXLTYI82segSPQc/GI+tj9vZssA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=haug1XZx5QidwRXW9adS9hA3qUJQHC3kmx3ykZJJaO/JcInjITSyJZ0E8UGJoJiId
         fbmNuKqzGZuvQ3+ldcQe96AEwuANWgTET17XjmbWdtle2C3odC+UhFYsJCJ9UhkynE
         j4iSJdIV73og75Esz/oKNBGpvJi0SfyG5zgrvNKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.19 87/97] iommu/vt-d: Fix compile warning from intel-svm.h
Date:   Thu, 27 Feb 2020 14:37:35 +0100
Message-Id: <20200227132228.792681478@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit e7598fac323aad0e502415edeffd567315994dd6 upstream.

The intel_svm_is_pasid_valid() needs to be marked inline, otherwise it
causes the compile warning below:

  CC [M]  drivers/dma/idxd/cdev.o
In file included from drivers/dma/idxd/cdev.c:9:0:
./include/linux/intel-svm.h:125:12: warning: ‘intel_svm_is_pasid_valid’ defined but not used [-Wunused-function]
 static int intel_svm_is_pasid_valid(struct device *dev, int pasid)
            ^~~~~~~~~~~~~~~~~~~~~~~~

Reported-by: Borislav Petkov <bp@alien8.de>
Fixes: 15060aba71711 ('iommu/vt-d: Helper function to query if a pasid has any active users')
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/intel-svm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/intel-svm.h
+++ b/include/linux/intel-svm.h
@@ -130,7 +130,7 @@ static inline int intel_svm_unbind_mm(st
 	BUG();
 }
 
-static int intel_svm_is_pasid_valid(struct device *dev, int pasid)
+static inline int intel_svm_is_pasid_valid(struct device *dev, int pasid)
 {
 	return -EINVAL;
 }


