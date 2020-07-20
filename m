Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAA8226B23
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730188AbgGTPs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729843AbgGTPs0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:48:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08F0C2065E;
        Mon, 20 Jul 2020 15:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260105;
        bh=x37chkiE3RibfOnCA9OownYkXilLTGLp6mdRMCznAfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZOXIpxv7gHv4NIs8+6Wn0uGPXV1+UKHZbA1TfIoSLm8JIJV3QX9mHNorhYGKmBkB
         n2JhANpXsoI6VzGZFFjg3l2XUUt5O2XTtwjSA+Fw8T/XLOoiEpYEwAQLlNbDjV5fSh
         BeF87XtsHeVDazbw+dxID8+nNIdmcOTuVUKZ3ksg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wade Mealing <wmealing@redhat.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 4.14 108/125] Revert "zram: convert remaining CLASS_ATTR() to CLASS_ATTR_RO()"
Date:   Mon, 20 Jul 2020 17:37:27 +0200
Message-Id: <20200720152808.244532027@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wade Mealing <wmealing@redhat.com>

commit 853eab68afc80f59f36bbdeb715e5c88c501e680 upstream.

Turns out that the permissions for 0400 really are what we want here,
otherwise any user can read from this file.

[fixed formatting, added changelog, and made attribute static - gregkh]

Reported-by: Wade Mealing <wmealing@redhat.com>
Cc: stable <stable@vger.kernel.org>
Fixes: f40609d1591f ("zram: convert remaining CLASS_ATTR() to CLASS_ATTR_RO()")
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1847832
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Link: https://lore.kernel.org/r/20200617114946.GA2131650@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/zram/zram_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1648,7 +1648,8 @@ static ssize_t hot_add_show(struct class
 		return ret;
 	return scnprintf(buf, PAGE_SIZE, "%d\n", ret);
 }
-static CLASS_ATTR_RO(hot_add);
+static struct class_attribute class_attr_hot_add =
+	__ATTR(hot_add, 0400, hot_add_show, NULL);
 
 static ssize_t hot_remove_store(struct class *class,
 			struct class_attribute *attr,


