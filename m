Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E0A431C34
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhJRNjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232115AbhJRNhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:37:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48429613DB;
        Mon, 18 Oct 2021 13:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563899;
        bh=FGM35nTA62kE6flpMLAyrF6LD12iQJC9R0HgxLPllvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h07rFXsMLCBs3xP7l6KGw+Jpo5Njo8Yz72k1ByDhafRFqAK7cYSmNX8Bh6oJ5cYU1
         ApiD0LUUtqI4Cpiibh238JqbgqYV7u8CAVlaU3LxrO4t0Qpue/bvJbyXoVs00np8k3
         EReGr9ckAwFm5AciTUrSOc2ob+bq7VMi+8pa0264=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.4 59/69] platform/mellanox: mlxreg-io: Fix argument base in kstrtou32() call
Date:   Mon, 18 Oct 2021 15:24:57 +0200
Message-Id: <20211018132331.426661817@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

commit 9b024201693e397441668cca0d2df7055fe572eb upstream.

Change kstrtou32() argument 'base' to be zero instead of 'len'.
It works by chance for setting one bit value, but it is not supposed to
work in case value passed to mlxreg_io_attr_store() is greater than 1.

It works for example, for:
echo 1 > /sys/devices/platform/mlxplat/mlxreg-io/hwmon/.../jtag_enable
But it will fail for:
echo n > /sys/devices/platform/mlxplat/mlxreg-io/hwmon/.../jtag_enable,
where n > 1.

The flow for input buffer conversion is as below:
_kstrtoull(const char *s, unsigned int base, unsigned long long *res)
calls:
rv = _parse_integer(s, base, &_res);

For the second case, where n > 1:
- _parse_integer() converts 's' to 'val'.
  For n=2, 'len' is set to 2 (string buffer is 0x32 0x0a), for n=3
  'len' is set to 3 (string buffer 0x33 0x0a), etcetera.
- 'base' is equal or greater then '2' (length of input buffer).

As a result, _parse_integer() exits with result zero (rv):
	rv = 0;
	while (1) {
		...
		if (val >= base)-> (2 >= 2)
			break;
		...
		rv++;
		...
	}

And _kstrtoull() in their turn will fail:
	if (rv == 0)
		return -EINVAL;

Fixes: 5ec4a8ace06c ("platform/mellanox: Introduce support for Mellanox register access driver")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/20210927142214.2613929-2-vadimp@nvidia.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/mellanox/mlxreg-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/mellanox/mlxreg-io.c
+++ b/drivers/platform/mellanox/mlxreg-io.c
@@ -123,7 +123,7 @@ mlxreg_io_attr_store(struct device *dev,
 		return -EINVAL;
 
 	/* Convert buffer to input value. */
-	ret = kstrtou32(buf, len, &input_val);
+	ret = kstrtou32(buf, 0, &input_val);
 	if (ret)
 		return ret;
 


