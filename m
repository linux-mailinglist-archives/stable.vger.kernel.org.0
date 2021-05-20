Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A7238AB8F
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239925AbhETLZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241216AbhETLXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:23:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD74B61D93;
        Thu, 20 May 2021 10:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505527;
        bh=Sz6EOdc7yV52bDWQgKlyk4LCblp+4sumZFTP9xmgSn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WPkNYby0RVXZ0wF7o8zRXbxXwhnvftJ7ieCIVHdouibYWx1KeDJpsiN4ooKjGIXKJ
         TLwdLGMW7ZuyP7KeXKXGkOPjoJRg43DQ2YEHouAnQJYsSuAFZjbib5nSMln5+C/V3U
         doSVaqX/gTIQSA5wLEPZCkGAKf9boVRMIVr+7LIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.4 175/190] dm ioctl: fix out of bounds array access when no devices
Date:   Thu, 20 May 2021 11:23:59 +0200
Message-Id: <20210520092107.957446529@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 4edbe1d7bcffcd6269f3b5eb63f710393ff2ec7a upstream.

If there are not any dm devices, we need to zero the "dev" argument in
the first structure dm_name_list. However, this can cause out of
bounds write, because the "needed" variable is zero and len may be
less than eight.

Fix this bug by reporting DM_BUFFER_FULL_FLAG if the result buffer is
too small to hold the "nl->dev" value.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[iwamatsu: Adjust context]
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -524,7 +524,7 @@ static int list_devices(struct dm_ioctl
 	 * Grab our output buffer.
 	 */
 	nl = get_result_buffer(param, param_size, &len);
-	if (len < needed) {
+	if (len < needed || len < sizeof(nl->dev)) {
 		param->flags |= DM_BUFFER_FULL_FLAG;
 		goto out;
 	}


