Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30748431E83
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbhJROBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:01:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234166AbhJRN75 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:59:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 284E861A7F;
        Mon, 18 Oct 2021 13:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564520;
        bh=HRFTNtA+EIHY4T1vUwID7BP9b/K85QKNpgaRKClWL5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tUAKat/5lmO+qWq1TJhTpdsGiVen+r1RqxDHiW1n88r4/k/bo1FdOSBGiwjIshXN1
         6k5TBsO1Kz7REIX6u53AHb2UznN9OogDEHZ3Prg1Rxhj+HjXHFHjBUsVCf5iOmJQKm
         SJ2vIQzMSdTX+KuyBZxhS4v13zyYdHCsIaz5kFUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.14 121/151] platform/mellanox: mlxreg-io: Fix argument base in kstrtou32() call
Date:   Mon, 18 Oct 2021 15:25:00 +0200
Message-Id: <20211018132344.609478403@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
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
@@ -141,7 +141,7 @@ mlxreg_io_attr_store(struct device *dev,
 		return -EINVAL;
 
 	/* Convert buffer to input value. */
-	ret = kstrtou32(buf, len, &input_val);
+	ret = kstrtou32(buf, 0, &input_val);
 	if (ret)
 		return ret;
 


