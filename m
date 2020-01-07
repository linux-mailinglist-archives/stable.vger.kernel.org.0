Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2DEB13307B
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgAGUQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:16:25 -0500
Received: from mout.kundenserver.de ([217.72.192.73]:55413 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728379AbgAGUQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 15:16:25 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MrQR7-1jS5Fh1b8x-00oVdi; Tue, 07 Jan 2020 21:16:06 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Oleksandr Natalenko <oleksandr@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Joe Eykholt <jeykholt@cisco.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Abhijeet Joglekar <abjoglek@cisco.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Colin Ian King <colin.king@canonical.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fnic: fix invalid stack access
Date:   Tue,  7 Jan 2020 21:15:49 +0100
Message-Id: <20200107201602.4096790-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:K1KYSV0cJGtVg+TJWCYsRWWJJ9TvxGO00fSnDNoLEwCbAThvW6P
 0dOMljJLPjjYc+Ef3QERcKvOdSQPtNIYqOzoz0ePAIvHo3LyPF2z9aEDIblaaNo9Q039lxT
 nL84AyTp+yP8K4G7074F7xDIhxZkvKxqWidkBRzl59oZXq4hMKzTx3RiEEc0gTOVCXSnk9Y
 omOZEVzHuiAcso91Xthwg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Tp6NYtjwL5I=:k5WIeqKeseUq8u9a+e4+A5
 /g1BxYrgwFO6nUsqbTvLYi2uU5w7Gp23F3cSVNxW69ikv6dICD103Q5aDnGXDbHpoOcqJu8yS
 BgGSHmtSdwM99j1grgcJ+XN6UjAo4w8B2BL6it/ulAfdGiD2JBbh3ZjDzc+NL54UITYNMTpSV
 ick6WeAYF15S6FavgY917Z/Z2RREK2QX8cYghH7rLlstxkBZhUsOnurhoRCNXWw8ncPpS9qf1
 hnBIo1o/dxsEOQ6vW4fSoMyYYylRWzYz0jKTMDsdL+1Q/q5JEgBYN66xHQvAz+23utjUB4Uyo
 w0vhX/s307hp5K7SSAniDvWdN0HusAmsQLXMVprpvrzpo+OWzt2DGgH/8y+KTC9HHB8chzxr8
 FOCt8brzZ1tjuvNgz/EXJSRHTBq4dO05u+Ol/a4USuAXUPMVzGB93Rx2sAwIB3Qav06Q/MibK
 3yxtCltDR34V6M0ekOQualyvnUaxmYqelYT2bpun7z4PA+MbkytweRLIZ+r2lt9os1JBnjS5L
 zM4YeJxSTp40irXhiPmDdEWm/sjmXhz9O9G1eEK32GnRf2h2eK0wQY1lwNlpGXkszzh6IZY2r
 sznsAkG4woV8FqaAe40CIR20zNMUU+7L6HUnbBvrCuLZWUHw1IuYHYLVMaykK7qEenijKoUpA
 klDdpw8t92Psp0Uz+HUphk114qYODoW9UI47ifTkEMf+oK9qDHLg5NbxGb72+rb3rIYDAd6cU
 HHQcRT6zZAu+hXUrjhczbxBTHXZ44VSbP9VdgTeIbNs3CxBpU4JC1Nak1yL3RlghMMEmTXXjV
 /ViHmUngA2ox8gOkCm6BuhTNI3UZXlKlKKmUB7BE8lKD+s3bHxLXJvldXc1hk83tHiUweWdBN
 kAFKkl2SuAkeDoiS/G5Q==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

gcc -O3 warns that some local variables are not properly initialized:

drivers/scsi/fnic/vnic_dev.c: In function 'fnic_dev_hang_notify':
drivers/scsi/fnic/vnic_dev.c:511:16: error: 'a0' is used uninitialized in this function [-Werror=uninitialized]
  vdev->args[0] = *a0;
  ~~~~~~~~~~~~~~^~~~~
drivers/scsi/fnic/vnic_dev.c:691:6: note: 'a0' was declared here
  u64 a0, a1;
      ^~
drivers/scsi/fnic/vnic_dev.c:512:16: error: 'a1' is used uninitialized in this function [-Werror=uninitialized]
  vdev->args[1] = *a1;
  ~~~~~~~~~~~~~~^~~~~
drivers/scsi/fnic/vnic_dev.c:691:10: note: 'a1' was declared here
  u64 a0, a1;
          ^~
drivers/scsi/fnic/vnic_dev.c: In function 'fnic_dev_mac_addr':
drivers/scsi/fnic/vnic_dev.c:512:16: error: 'a1' is used uninitialized in this function [-Werror=uninitialized]
  vdev->args[1] = *a1;
  ~~~~~~~~~~~~~~^~~~~
drivers/scsi/fnic/vnic_dev.c:698:10: note: 'a1' was declared here
  u64 a0, a1;
          ^~

Apparently the code relies on the local variables occupying
adjacent memory locations in the same order, but this is of
course not guaranteed.

Use an array of two u64 variables where needed to make it work
correctly.

I suspect there is also an endianess bug here, but have not
digged in deep enough to be sure.

Cc: stable@vger.kernel.org
Fixes: 5df6d737dd4b ("[SCSI] fnic: Add new Cisco PCI-Express FCoE HBA")
Fixes: mmtom ("init/Kconfig: enable -O3 for all arches")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/fnic/vnic_dev.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
index 1f55b9e4e74a..1b88a3b53eee 100644
--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -688,26 +688,26 @@ int vnic_dev_soft_reset_done(struct vnic_dev *vdev, int *done)
 
 int vnic_dev_hang_notify(struct vnic_dev *vdev)
 {
-	u64 a0, a1;
+	u64 a0 = 0, a1 = 0;
 	int wait = 1000;
 	return vnic_dev_cmd(vdev, CMD_HANG_NOTIFY, &a0, &a1, wait);
 }
 
 int vnic_dev_mac_addr(struct vnic_dev *vdev, u8 *mac_addr)
 {
-	u64 a0, a1;
+	u64 a[2] = {};
 	int wait = 1000;
 	int err, i;
 
 	for (i = 0; i < ETH_ALEN; i++)
 		mac_addr[i] = 0;
 
-	err = vnic_dev_cmd(vdev, CMD_MAC_ADDR, &a0, &a1, wait);
+	err = vnic_dev_cmd(vdev, CMD_MAC_ADDR, &a[0], &a[1], wait);
 	if (err)
 		return err;
 
 	for (i = 0; i < ETH_ALEN; i++)
-		mac_addr[i] = ((u8 *)&a0)[i];
+		mac_addr[i] = ((u8 *)&a)[i];
 
 	return 0;
 }
@@ -732,30 +732,30 @@ void vnic_dev_packet_filter(struct vnic_dev *vdev, int directed, int multicast,
 
 void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *addr)
 {
-	u64 a0 = 0, a1 = 0;
+	u64 a[2] = {};
 	int wait = 1000;
 	int err;
 	int i;
 
 	for (i = 0; i < ETH_ALEN; i++)
-		((u8 *)&a0)[i] = addr[i];
+		((u8 *)&a)[i] = addr[i];
 
-	err = vnic_dev_cmd(vdev, CMD_ADDR_ADD, &a0, &a1, wait);
+	err = vnic_dev_cmd(vdev, CMD_ADDR_ADD, &a[0], &a[1], wait);
 	if (err)
 		pr_err("Can't add addr [%pM], %d\n", addr, err);
 }
 
 void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
 {
-	u64 a0 = 0, a1 = 0;
+	u64 a[2] = {};
 	int wait = 1000;
 	int err;
 	int i;
 
 	for (i = 0; i < ETH_ALEN; i++)
-		((u8 *)&a0)[i] = addr[i];
+		((u8 *)&a)[i] = addr[i];
 
-	err = vnic_dev_cmd(vdev, CMD_ADDR_DEL, &a0, &a1, wait);
+	err = vnic_dev_cmd(vdev, CMD_ADDR_DEL, &a[0], &a[1], wait);
 	if (err)
 		pr_err("Can't del addr [%pM], %d\n", addr, err);
 }
-- 
2.20.0

