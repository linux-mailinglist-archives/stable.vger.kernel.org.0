Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E251D0D46
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387684AbgEMJvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:51:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387682AbgEMJvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:51:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8927B206D6;
        Wed, 13 May 2020 09:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363499;
        bh=lbc0ZkuPyvr62w63DEgAjqvxm+QSLWvjl3b/t0QNdjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PqmB9nB8Aa5us0IZXAXVjSvB4lls5JKhUjh5qPqIFsa+TXw5qm3M+sYCCNTUCi91w
         gVnF6qgzg1xR6t8pDMlwHhZMaAI1YLYsFXNTMXY6TdKalHjNED7rpqsakxLrnrnexD
         r9FilP+jnZ0dLvUvrmH8DtOFTQCuL8e7ST0XNgTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <yehezkelshb@gmail.com>
Subject: [PATCH 5.6 001/118] thunderbolt: Check return value of tb_sw_read() in usb4_switch_op()
Date:   Wed, 13 May 2020 11:43:40 +0200
Message-Id: <20200513094417.748040775@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit c3bf9930921b33edb31909006607e478751a6f5e upstream.

The function misses checking return value of tb_sw_read() before it
accesses the value that was read. Fix this by checking the return value
first.

Fixes: b04079837b20 ("thunderbolt: Add initial support for USB4")
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Yehezkel Bernat <yehezkelshb@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/thunderbolt/usb4.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -182,6 +182,9 @@ static int usb4_switch_op(struct tb_swit
 		return ret;
 
 	ret = tb_sw_read(sw, &val, TB_CFG_SWITCH, ROUTER_CS_26, 1);
+	if (ret)
+		return ret;
+
 	if (val & ROUTER_CS_26_ONS)
 		return -EOPNOTSUPP;
 


