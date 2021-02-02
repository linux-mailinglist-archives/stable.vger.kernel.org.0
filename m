Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B87730C841
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 18:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237861AbhBBRqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 12:46:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:48844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233682AbhBBOKj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:10:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6B526503D;
        Tue,  2 Feb 2021 13:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273875;
        bh=Co5qTz3j+kM+L+4KifKZPZo7aVOMuumGsmbfabtcpuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKBevhJOZ4I6rHvTcbokNHx1wD5H9FdhnJdTlfwvVgiQGQarytAIxuk9v1UDxB+Wr
         Nx0Ye+hqLpUk44MdZsYgDgu1dE56Ecl5FaWzwo4OTdGowzuc15FAlLNgDhz8xt2Tn9
         gZPDAx5/Hpinirl+Ocbzq7LnU3AvWkwHzjGlKXqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 32/32] NFC: fix possible resource leak
Date:   Tue,  2 Feb 2021 14:38:55 +0100
Message-Id: <20210202132943.304393716@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.035179752@linuxfoundation.org>
References: <20210202132942.035179752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

commit d8f923c3ab96dbbb4e3c22d1afc1dc1d3b195cd8 upstream.

Put the device to avoid resource leak on path that the polling flag is
invalid.

Fixes: a831b9132065 ("NFC: Do not return EBUSY when stopping a poll that's already stopped")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Link: https://lore.kernel.org/r/20210121153745.122184-1-bianpan2016@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/nfc/netlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -887,6 +887,7 @@ static int nfc_genl_stop_poll(struct sk_
 
 	if (!dev->polling) {
 		device_unlock(&dev->dev);
+		nfc_put_device(dev);
 		return -EINVAL;
 	}
 


