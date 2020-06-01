Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7519E1EAF34
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 21:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbgFAR4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728760AbgFAR4y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:56:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89680207D0;
        Mon,  1 Jun 2020 17:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034214;
        bh=jmdWX0SZuQKksabiIIN5yQmlcrrl6R9CUJOj0zjDu6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2p4/EpaiJJOC2dvXsu5e2kArRdbvwaQodzyB0R65L+V/SxTysok9tMlLDNG9I3cfK
         7JISn33z+5IIhVNsF4QcnkiYVgOhneltF96ap1oW9NTZUk8ETI2WCo4fcW7+lZA93E
         MiIoqyLqotUwl87ojC+5tIJ7pEB3smIaJ9Q7Ur2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Calaby <julian.calaby@gmail.com>,
        Sudip Mukherjee <sudip@vectorindia.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 43/48] mac80211: fix memory leak
Date:   Mon,  1 Jun 2020 19:53:53 +0200
Message-Id: <20200601174004.493887733@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601173952.175939894@linuxfoundation.org>
References: <20200601173952.175939894@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudip Mukherjee <sudip@vectorindia.org>

commit ea32f065bd3e3e09f0bcb3042f1664caf6b3e233 upstream.

On error we jumped to the error label and returned the error code but we
missed releasing sinfo.

Fixes: 5fe74014172d ("mac80211: avoid excessive stack usage in sta_info")
Reviewed-by: Julian Calaby <julian.calaby@gmail.com>
Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/sta_info.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -555,6 +555,7 @@ static int sta_info_insert_finish(struct
 	__cleanup_single_sta(sta);
  out_err:
 	mutex_unlock(&local->sta_mtx);
+	kfree(sinfo);
 	rcu_read_lock();
 	return err;
 }


