Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE4B1A51EC
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgDKMLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:11:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbgDKMLt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:11:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 379B9216FD;
        Sat, 11 Apr 2020 12:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607109;
        bh=X2BENBbLy6MCfSpp22+T3ekykdiJL3kEpY4A+B45mYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NRaP1VJ/1YTW7lzKcp5kN7ig45WW1z6IeYjq1RJK4LARDNqg3avLvcc0wWBkMQYs4
         h8ETxQ95hpxqHtS+2rQS3A8h8kUyv3EStF4XJA0/3DbMcrlfj6M0GLAGTHOpwmEjzU
         dFvd+V7e4UWcwQWuRfqfrskfgNvkMxaXO8ZZu9/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eugene Syromiatnikov <esyr@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.9 11/32] coresight: do not use the BIT() macro in the UAPI header
Date:   Sat, 11 Apr 2020 14:08:50 +0200
Message-Id: <20200411115419.838338654@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115418.455500023@linuxfoundation.org>
References: <20200411115418.455500023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugene Syromiatnikov <esyr@redhat.com>

commit 9b6eaaf3db5e5888df7bca7fed7752a90f7fd871 upstream.

The BIT() macro definition is not available for the UAPI headers
(moreover, it can be defined differently in the user space); replace
its usage with the _BITUL() macro that is defined in <linux/const.h>.

Fixes: 237483aa5cf4 ("coresight: stm: adding driver for CoreSight STM component")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200324042213.GA10452@asgard.redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/coresight-stm.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/coresight-stm.h
+++ b/include/uapi/linux/coresight-stm.h
@@ -1,8 +1,10 @@
 #ifndef __UAPI_CORESIGHT_STM_H_
 #define __UAPI_CORESIGHT_STM_H_
 
-#define STM_FLAG_TIMESTAMPED   BIT(3)
-#define STM_FLAG_GUARANTEED    BIT(7)
+#include <linux/const.h>
+
+#define STM_FLAG_TIMESTAMPED   _BITUL(3)
+#define STM_FLAG_GUARANTEED    _BITUL(7)
 
 /*
  * The CoreSight STM supports guaranteed and invariant timing


