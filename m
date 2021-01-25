Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49143304B5A
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbhAZErF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:47:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:58164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728662AbhAYSnm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:43:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEA112074B;
        Mon, 25 Jan 2021 18:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600195;
        bh=Mv2rqlaJW1BoCRBzU6hB7XGeAPeXtLJmXqqtg6DUfBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfAbpqdeRfWHwoecVvzG7+ZJnX7li0cnhBgSUEjX0I8aAkLxOnm3EOjHA3/JjvAjl
         6xS/qLYer6GBSkCfHoPgzZOw6Kbe9EE5bmmqslXhkE/Yti5fv7F0wMci8kIWLEyCe4
         YCtO6p+a88so0mQ2a2Wo+IyvyXncma7fc6MiL/7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikko Perttunen <mperttunen@nvidia.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.4 01/86] i2c: bpmp-tegra: Ignore unknown I2C_M flags
Date:   Mon, 25 Jan 2021 19:38:43 +0100
Message-Id: <20210125183201.091280052@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

commit bc1c2048abbe3c3074b4de91d213595c57741a6b upstream.

In order to not to start returning errors when new I2C_M flags are
added, change behavior to just ignore all flags that we don't know
about. This includes the I2C_M_DMA_SAFE flag that already exists but
causes -EINVAL to be returned for valid transactions.

Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-tegra-bpmp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-tegra-bpmp.c
+++ b/drivers/i2c/busses/i2c-tegra-bpmp.c
@@ -80,7 +80,7 @@ static int tegra_bpmp_xlate_flags(u16 fl
 		flags &= ~I2C_M_RECV_LEN;
 	}
 
-	return (flags != 0) ? -EINVAL : 0;
+	return 0;
 }
 
 /**


