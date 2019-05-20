Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 137E02355C
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390976AbfETMem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:34:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387444AbfETMel (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:34:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7758320645;
        Mon, 20 May 2019 12:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355681;
        bh=T8dAJpl6NQ3up2szpVSvaWP2GQMjzLSzmhNE8uxP6YY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zxABOdsmYE+WXf1bvj+PYKKuDdzkpBJ2uU39F1UYvpo13SodPtEddnxzkHiqFWMkK
         xAlRpF9z5z1Zoqn3liRDGdEXTxu/xU0z2/zHQ9HPXIiB3jKCZaI8hhI3/dQKBg7UBM
         mVtZr5DlpgooBtwuvjS2UMaBVsKAX+kfPOLwBEmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.1 043/128] drivers/dax: Allow to include DEV_DAX_PMEM as builtin
Date:   Mon, 20 May 2019 14:13:50 +0200
Message-Id: <20190520115252.634655843@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

commit 67476656febd7ec5f1fe1aeec3c441fcf53b1e45 upstream.

This move the dependency to DEV_DAX_PMEM_COMPAT such that only
if DEV_DAX_PMEM is built as module we can allow the compat support.

This allows to test the new code easily in a emulation setup where we
often build things without module support.

Cc: <stable@vger.kernel.org>
Fixes: 730926c3b099 ("device-dax: Add /sys/class/dax backwards compatibility")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dax/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -23,7 +23,6 @@ config DEV_DAX
 config DEV_DAX_PMEM
 	tristate "PMEM DAX: direct access to persistent memory"
 	depends on LIBNVDIMM && NVDIMM_DAX && DEV_DAX
-	depends on m # until we can kill DEV_DAX_PMEM_COMPAT
 	default DEV_DAX
 	help
 	  Support raw access to persistent memory.  Note that this
@@ -50,7 +49,7 @@ config DEV_DAX_KMEM
 
 config DEV_DAX_PMEM_COMPAT
 	tristate "PMEM DAX: support the deprecated /sys/class/dax interface"
-	depends on DEV_DAX_PMEM
+	depends on m && DEV_DAX_PMEM=m
 	default DEV_DAX_PMEM
 	help
 	  Older versions of the libdaxctl library expect to find all


