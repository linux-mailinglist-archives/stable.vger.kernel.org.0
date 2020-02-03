Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29A48150DF4
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgBCQsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:48:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:37496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729187AbgBCQ0c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:26:32 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96C902051A;
        Mon,  3 Feb 2020 16:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747191;
        bh=2KLD0sJk2Cbx1wymConOooNrrg7yNCXRvjpJb1zNXlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hs+qaXSxKvq2iQo1BgBx5jo1CA3raMLuYfhWzB2H6di5nXvXU4j8bU7v1UBx97PHD
         8fVfyfWXYaPSkMmdetF+MjbHfdezPAfeV4D8pVdPSX8kXgj7hHr2N9LrBr3TpSbiDi
         8xvkaYyrfqEE7rFy1+Tby/xn0KOPjdjOEwIFLcXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 4.9 08/68] staging: wlan-ng: ensure error return is actually returned
Date:   Mon,  3 Feb 2020 16:19:04 +0000
Message-Id: <20200203161906.244864664@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
References: <20200203161904.705434837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 4cc41cbce536876678b35e03c4a8a7bb72c78fa9 upstream.

Currently when the call to prism2sta_ifst fails a netdev_err error
is reported, error return variable result is set to -1 but the
function always returns 0 for success.  Fix this by returning
the error value in variable result rather than 0.

Addresses-Coverity: ("Unused value")
Fixes: 00b3ed168508 ("Staging: add wlan-ng prism2 usb driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200114181604.390235-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/wlan-ng/prism2mgmt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/wlan-ng/prism2mgmt.c
+++ b/drivers/staging/wlan-ng/prism2mgmt.c
@@ -938,7 +938,7 @@ int prism2mgmt_flashdl_state(struct wlan
 		}
 	}
 
-	return 0;
+	return result;
 }
 
 /*----------------------------------------------------------------


