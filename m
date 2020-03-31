Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 129BD1991E9
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730974AbgCaJWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:22:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731155AbgCaJHe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:07:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3EC720B80;
        Tue, 31 Mar 2020 09:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645654;
        bh=sQsKAGMwDmKlXneFcDernatCFdyacNP8NlyojPzSbOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ylkQgcd9ZcHN3/d45ph1kfa2iPd6roQu7eImLw+NQs+913blsqaVdJLPCokSu5b27
         PRwnYmIezLc50fcatmcP9qn9D6J9xuDL9HNWZLCUSWX4nbekt/QYda+arOHEcPfEGx
         ZJV3ajV+Bz4PNVXHW7r0op/V4olHlaSut1ob45pA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raed Salem <raeds@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.5 122/170] xfrm: handle NETDEV_UNREGISTER for xfrm device
Date:   Tue, 31 Mar 2020 10:58:56 +0200
Message-Id: <20200331085436.978428749@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

commit 03891f820c2117b19e80b370281eb924a09cf79f upstream.

This patch to handle the asynchronous unregister
device event so the device IPsec offload resources
could be cleanly released.

Fixes: e4db5b61c572 ("xfrm: policy: remove pcpu policy cache")
Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xfrm/xfrm_device.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -390,6 +390,7 @@ static int xfrm_dev_event(struct notifie
 		return xfrm_dev_feat_change(dev);
 
 	case NETDEV_DOWN:
+	case NETDEV_UNREGISTER:
 		return xfrm_dev_down(dev);
 	}
 	return NOTIFY_DONE;


