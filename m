Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6FE449E9BE
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244843AbiA0SJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244918AbiA0SJM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:09:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE4BC061749;
        Thu, 27 Jan 2022 10:09:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89AB4B820C8;
        Thu, 27 Jan 2022 18:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2ACAC340E4;
        Thu, 27 Jan 2022 18:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643306949;
        bh=5jAhF6s48ZQ1C5c4o0UZAxNRdfaT0yBP3ccQ6rwBZSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mTAlyzSRvrl9EJtFvIo5CKp6EHZX527x5IFu+AfC9pq+ndhm4pbqEsb58FpkeJOJF
         7nEl8VqVEb3OSjweszEbtl2N0rJhxeIl8P9/D2ceocTL/ZlmzGoa6PNkCTAW0qyZ61
         UAm4W9x6j5h8dLWySrDs0Fwfr1OUiEwahoq1bkoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, lee.jones@linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 4.9 9/9] ion: Do not put ION handle until after its final use
Date:   Thu, 27 Jan 2022 19:08:27 +0100
Message-Id: <20220127180257.527413926@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180257.225641300@linuxfoundation.org>
References: <20220127180257.225641300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

pass_to_user() eventually calls kref_put() on an ION handle which is
still live, potentially allowing for it to be legitimately freed by
the client.

Prevent this from happening before its final use in both ION_IOC_ALLOC
and ION_IOC_IMPORT.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/android/ion/ion-ioctl.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/staging/android/ion/ion-ioctl.c
+++ b/drivers/staging/android/ion/ion-ioctl.c
@@ -165,10 +165,9 @@ long ion_ioctl(struct file *filp, unsign
 				     data.allocation.flags, true);
 		if (IS_ERR(handle))
 			return PTR_ERR(handle);
-		pass_to_user(handle);
 		data.allocation.handle = handle->id;
-
 		cleanup_handle = handle;
+		pass_to_user(handle);
 		break;
 	}
 	case ION_IOC_FREE:
@@ -212,11 +211,12 @@ long ion_ioctl(struct file *filp, unsign
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 		} else {
+			data.handle.handle = handle->id;
 			handle = pass_to_user(handle);
-			if (IS_ERR(handle))
+			if (IS_ERR(handle)) {
 				ret = PTR_ERR(handle);
-			else
-				data.handle.handle = handle->id;
+				data.handle.handle = 0;
+			}
 		}
 		break;
 	}


