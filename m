Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD71E2E3E20
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503045AbgL1OYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:24:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:60164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503005AbgL1OYT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:24:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 584DC22B3B;
        Mon, 28 Dec 2020 14:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165443;
        bh=ycu+JE1DE1QEQDhy6MtUTnnqk2x6wQmu47w4i+VT+l0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jl9STrmU2LpkWW4MQWIkLI5ZPiwP1IZ2YEeIMJ7XZdd+yDy2HeZAEcGduPnPfcNPw
         C5wBJf00tn8p6mZe9J3+aaFyUYTgUmc9pOYBuoaBxHC/n+kuJI+xVqQphomk7U9D9e
         VHqz2sDd4M9eD5CBeUdxKSw/7AWUnINCiTByZql8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Scally <djrscally@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 533/717] Revert "ACPI / resources: Use AE_CTRL_TERMINATE to terminate resources walks"
Date:   Mon, 28 Dec 2020 13:48:51 +0100
Message-Id: <20201228125046.506749180@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Scally <djrscally@gmail.com>

commit 12fc4dad94dfac25599f31257aac181c691ca96f upstream.

This reverts commit 8a66790b7850a6669129af078768a1d42076a0ef.

Switching this function to AE_CTRL_TERMINATE broke the documented
behaviour of acpi_dev_get_resources() - AE_CTRL_TERMINATE does not, in
fact, terminate the resource walk because acpi_walk_resource_buffer()
ignores it (specifically converting it to AE_OK), referring to that
value as "an OK termination by the user function". This means that
acpi_dev_get_resources() does not abort processing when the preproc
function returns a negative value.

Signed-off-by: Daniel Scally <djrscally@gmail.com>
Cc: 3.10+ <stable@vger.kernel.org> # 3.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -541,7 +541,7 @@ static acpi_status acpi_dev_process_reso
 		ret = c->preproc(ares, c->preproc_data);
 		if (ret < 0) {
 			c->error = ret;
-			return AE_CTRL_TERMINATE;
+			return AE_ABORT_METHOD;
 		} else if (ret > 0) {
 			return AE_OK;
 		}


