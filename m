Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE0B2B9CF7
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 22:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgKSVa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 16:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgKSVa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 16:30:26 -0500
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D08DC0613CF;
        Thu, 19 Nov 2020 13:30:26 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4CcXsC73FkzQlJX;
        Thu, 19 Nov 2020 22:30:23 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1605821421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7LSU0rBQtbYzA51UsH5RyNKMAMpJqufgAfP3TKlPP38=;
        b=RpStEnFwwGaUxyDLB73EtCuL9QmRjnxISRxl906iWhCVEJZaE3p32LWhQlbAeIVnd5c2Kr
        yzznLLzrikQQrsoe8jpOGPktJq/NjyQ69t6V+H2oQ8pSZNjvwyxtzaWS/fsPqXQcpbGEW7
        iPxU7gAyw4Y72gs5svPZOWuwYzetKbSkLOP11SQSkHvuwhjF/Py+NjcZ39DPsS2nyZoDbA
        q7+B1H+elYxAhRJ3MbLdmAB2EmjnHR3KoKUJ6a+HkVKiYagz45Q6JJ+NOKtVY7YyKN6UoT
        tHVAlE8N3JvyfCZvjzZNIuwOeOQ+/w3CHTwLu8oJo0qRXwp5OtvT/WNMOVpGZg==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id B2JDPRT6gkDZ; Thu, 19 Nov 2020 22:30:19 +0100 (CET)
To:     stable <stable@vger.kernel.org>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Cc:     Mike Looijmans <mike.looijmans@topic.nl>,
        Phil Reid <preid@electromag.com.au>,
        "Signed-off-by: Peter Rosin" <peda@axentia.se>,
        ", linux-i2c"@vger.kernel.org
Subject: stable backport of "i2c: mux: pca954x: Add missing pca9546 definition
 to chip_desc"
Message-ID: <5e6b816b-60e8-f2a0-5e84-841940b0aa0d@hauke-m.de>
Date:   Thu, 19 Nov 2020 22:30:17 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.84 / 15.00 / 15.00
X-Rspamd-Queue-Id: 002A417DD
X-Rspamd-UID: c79493
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please backport "i2c: mux: pca954x: Add missing pca9546 definition to 
chip_desc" to kernel 4.9.
This is upstream commit id dbe4d69d252e9e65c6c46826980b77b11a142065
https://git.kernel.org/linus/dbe4d69d252e9e65c6c46826980b77b11a142065

commit dbe4d69d252e9e65c6c46826980b77b11a142065
Author: Mike Looijmans <mike.looijmans@topic.nl>
Date:   Thu Mar 23 10:00:36 2017 +0100

     i2c: mux: pca954x: Add missing pca9546 definition to chip_desc


The pca954x_of_match table references the chips array at position 
pca_9546, but this entry is not filled before.

When a device tree contains a compatible string with "nxp,pca9546", it 
will not load successfully without this patch.

This problem was introduced in commit 8a191a7ad4ca ("i2c: pca954x: add 
device tree binding") in v4.9 and is fixed upstream with kernel version 
4.11.


The commit f8251f1dfda9 ("i2c: mux: pca954x: Add missing pca9542 
definition to chip_desc") fixes a similar problem with the pca9542.
https://git.kernel.org/linus/f8251f1dfda9e1200545bf19270d9df2273bdfa1
The changes in the pca954x_acpi_ids should not be backported as it does 
not exist in 4.9.

Hauke
