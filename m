Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1039B157965
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbgBJNPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:15:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:33984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728553AbgBJMi0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:26 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E88120838;
        Mon, 10 Feb 2020 12:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338306;
        bh=L4r5YMKdPeOtPohxU0GhCvCY682DwqDYJCwck78rRGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ksxovjk2dderoQrzxvJq6cQYEkm06xmaLnKqfL40Ye3HxX7OFE9SUbG1m/tJgvCOi
         M4n9ZtlBkJcH9o2UjB6W1mrdJ81Le7IeTVYrIXxNcqOpFllO7DuiyNNlirNYIeecNx
         NToDRqEB+XtjNjlI0KtDRQGfjF+C0+VHoR3lgVRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, huangwen <huangwenabc@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 181/309] mwifiex: fix unbalanced locking in mwifiex_process_country_ie()
Date:   Mon, 10 Feb 2020 04:32:17 -0800
Message-Id: <20200210122423.899697749@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

commit 65b1aae0d9d5962faccc06bdb8e91a2a0b09451c upstream.

We called rcu_read_lock(), so we need to call rcu_read_unlock() before
we return.

Fixes: 3d94a4a8373b ("mwifiex: fix possible heap overflow in mwifiex_process_country_ie()")
Cc: stable@vger.kernel.org
Cc: huangwen <huangwenabc@gmail.com>
Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Acked-by: Ganapathi Bhat <ganapathi.bhat@nxp.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -232,6 +232,7 @@ static int mwifiex_process_country_ie(st
 
 	if (country_ie_len >
 	    (IEEE80211_COUNTRY_STRING_LEN + MWIFIEX_MAX_TRIPLET_802_11D)) {
+		rcu_read_unlock();
 		mwifiex_dbg(priv->adapter, ERROR,
 			    "11D: country_ie_len overflow!, deauth AP\n");
 		return -EINVAL;


