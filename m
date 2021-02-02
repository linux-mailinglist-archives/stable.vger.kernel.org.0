Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9919A30C127
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234234AbhBBOOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:14:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233829AbhBBOMf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:12:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47F1F64FB0;
        Tue,  2 Feb 2021 13:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273951;
        bh=7zJJntLKaEfHwAfyaVTTHXnrnswbDbeif0bIJQpPAVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/mB2aMoITqns6gxxZGvUncupENCR0Z9lA0v3Barl1DGGDZupq7mmwgOfTLl3j04z
         EjgSAn/K2cOydDzEgCyn5yrmILVT4QPnTp9Ep0MPm9yfkz3O1v1iFSY6g+mhXs+0JA
         1qIsxbWO26hsV5qicbRaRhalRRMR6NwOHbi6VGTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 28/30] NFC: fix possible resource leak
Date:   Tue,  2 Feb 2021 14:39:09 +0100
Message-Id: <20210202132943.279721069@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.138623851@linuxfoundation.org>
References: <20210202132942.138623851@linuxfoundation.org>
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
@@ -884,6 +884,7 @@ static int nfc_genl_stop_poll(struct sk_
 
 	if (!dev->polling) {
 		device_unlock(&dev->dev);
+		nfc_put_device(dev);
 		return -EINVAL;
 	}
 


