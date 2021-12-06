Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A9A46999C
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 15:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344136AbhLFPCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:02:08 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52840 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343709AbhLFPCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:02:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2131612D3;
        Mon,  6 Dec 2021 14:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D90C341C2;
        Mon,  6 Dec 2021 14:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802718;
        bh=Hhlbw8AxhK7obTAW16YMJtftZaHl4MPLEEfRrHOmRXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QELTaFMRVxRwuz/1+6vygdKV6EtBj5EHkWlC/OCOpcJAzZlJTCqjSDN1g7KUihDbw
         Q0LO+qPr6C33n4k8nNLdECN/mnx5evx1Ku8mw/ZyXlDc4qvRfgaXiWWPy7CDKcv4oR
         vX7g59MQI9gUyEGJ9sKOYtkw4Hm5/kn82sykdfLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, lee.jones@linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "devel@driverdev.osuosl.org, arve@android.com, stable@vger.kernel.org,
        riandrews@android.com, labbott@redhat.com, sumit.semwal@linaro.org, Dan
        Carpenter" <dan.carpenter@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4.4 01/52] staging: ion: Prevent incorrect reference counting behavour
Date:   Mon,  6 Dec 2021 15:55:45 +0100
Message-Id: <20211206145547.942588455@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145547.892668902@linuxfoundation.org>
References: <20211206145547.892668902@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

Supply additional checks in order to prevent unexpected results.

Fixes: b892bf75b2034 ("ion: Switch ion to use dma-buf")
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/android/ion/ion.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -606,6 +606,9 @@ static void *ion_buffer_kmap_get(struct
 	void *vaddr;
 
 	if (buffer->kmap_cnt) {
+		if (buffer->kmap_cnt == INT_MAX)
+			return ERR_PTR(-EOVERFLOW);
+
 		buffer->kmap_cnt++;
 		return buffer->vaddr;
 	}
@@ -626,6 +629,9 @@ static void *ion_handle_kmap_get(struct
 	void *vaddr;
 
 	if (handle->kmap_cnt) {
+		if (handle->kmap_cnt == INT_MAX)
+			return ERR_PTR(-EOVERFLOW);
+
 		handle->kmap_cnt++;
 		return buffer->vaddr;
 	}


