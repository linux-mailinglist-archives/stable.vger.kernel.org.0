Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A28A37F592
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 12:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbhEMK1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 06:27:13 -0400
Received: from mo-csw-fb1515.securemx.jp ([210.130.202.171]:49530 "EHLO
        mo-csw-fb.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbhEMK1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 06:27:09 -0400
X-Greylist: delayed 2382 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 May 2021 06:27:08 EDT
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1515) id 14D9kExB031895; Thu, 13 May 2021 18:46:14 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id 14D9k0Sc000811; Thu, 13 May 2021 18:46:00 +0900
X-Iguazu-Qid: 34tKC7reXM0U9in9wy
X-Iguazu-QSIG: v=2; s=0; t=1620899159; q=34tKC7reXM0U9in9wy; m=bdtHbKZafRhEJ9oe09JQKGLmQlb2E+pb1imK/YHITLM=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1513) id 14D9jxx3004538
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 13 May 2021 18:45:59 +0900
Received: from enc01.toshiba.co.jp (enc01.toshiba.co.jp [106.186.93.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx2-a.toshiba.co.jp (Postfix) with ESMTPS id 19B8F1000E6;
        Thu, 13 May 2021 18:45:59 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 14D9jwtW013915;
        Thu, 13 May 2021 18:45:58 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.4 and 4.9] dm ioctl: fix out of bounds array access when no devices
Date:   Thu, 13 May 2021 18:45:52 +0900
X-TSB-HOP: ON
Message-Id: <20210513094552.266451-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
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
---
 drivers/md/dm-ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 836a2808c0c712..eb2659a1231081 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -524,7 +524,7 @@ static int list_devices(struct dm_ioctl *param, size_t param_size)
 	 * Grab our output buffer.
 	 */
 	nl = get_result_buffer(param, param_size, &len);
-	if (len < needed) {
+	if (len < needed || len < sizeof(nl->dev)) {
 		param->flags |= DM_BUFFER_FULL_FLAG;
 		goto out;
 	}
-- 
2.30.0

