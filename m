Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9EEB4FB36C
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 08:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbiDKGFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 02:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiDKGFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 02:05:11 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A904A33E1C;
        Sun, 10 Apr 2022 23:02:56 -0700 (PDT)
Received: from localhost.localdomain (unknown [222.205.8.117])
        by mail-app3 (Coremail) with SMTP id cC_KCgC3f3mHxFNi5gvbAQ--.41928S4;
        Mon, 11 Apr 2022 14:02:48 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        mdharm-usb@one-eyed-alien.net
Cc:     Lin Ma <linma@zju.edu.cn>, stable@vger.kernel.org
Subject: [PATCH v2] USB: storage: karma: fix rio_karma_init return
Date:   Mon, 11 Apr 2022 14:02:46 +0800
Message-Id: <20220411060246.9887-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cC_KCgC3f3mHxFNi5gvbAQ--.41928S4
X-Coremail-Antispam: 1UD129KBjvJXoW7CrWUtw48GFW5Xr48CFyrCrg_yoW8GF1kpa
        ykJry5CFyUJF1fGr9rX34DuFy5Can7tFWjga4fG3ZY9rsrJF48CF42va4093ZYqrySkF1x
        tF4vkFyagrn8AFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk21xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxF
        aVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
        4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxG
        rwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8Jw
        CI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2
        z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The function rio_karam_init() should return -ENOMEM instead of
value 0 (USB_STOR_TRANSPORT_GOOD) when allocation fails.

Simlarlly, it should return -EIO when rio_karma_send_command() fails.

Cc: stable@vger.kernel.org
Fixes: dfe0d3ba20e8 ("USB Storage: add rio karma eject support")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 drivers/usb/storage/karma.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/storage/karma.c b/drivers/usb/storage/karma.c
index 05cec81dcd3f..38ddfedef629 100644
--- a/drivers/usb/storage/karma.c
+++ b/drivers/usb/storage/karma.c
@@ -174,24 +174,25 @@ static void rio_karma_destructor(void *extra)
 
 static int rio_karma_init(struct us_data *us)
 {
-	int ret = 0;
 	struct karma_data *data = kzalloc(sizeof(struct karma_data), GFP_NOIO);
 
 	if (!data)
-		goto out;
+		return -ENOMEM;
 
 	data->recv = kmalloc(RIO_RECV_LEN, GFP_NOIO);
 	if (!data->recv) {
 		kfree(data);
-		goto out;
+		return -ENOMEM;
 	}
 
 	us->extra = data;
 	us->extra_destructor = rio_karma_destructor;
-	ret = rio_karma_send_command(RIO_ENTER_STORAGE, us);
-	data->in_storage = (ret == 0);
-out:
-	return ret;
+	if (rio_karma_send_command(RIO_ENTER_STORAGE, us))
+		return -EIO;
+
+	data->in_storage = 1;
+
+	return 0;
 }
 
 static struct scsi_host_template karma_host_template;
-- 
2.35.1

