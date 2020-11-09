Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67DB2AB29D
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 09:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgKIImb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 03:42:31 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:27510 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbgKIImb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 03:42:31 -0500
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20201109084227epoutp03abde45a1f5e93de0ced7cdd1441185fc~Fyl4fZ7nH2329023290epoutp03F
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 08:42:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20201109084227epoutp03abde45a1f5e93de0ced7cdd1441185fc~Fyl4fZ7nH2329023290epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1604911347;
        bh=hnFYwtXuO8MJM/pIWWZpjBvGRy1uzP3Ew6oWUOUIP0A=;
        h=From:To:Cc:Subject:Date:References:From;
        b=o1oqgqqvIacRO83P9FYsx1Gsu1vK9fir6OKk1e/Rydx+fHI5Aqw6H8Jkk/SSE9sPA
         EX/v4PNtSySXLy6zE1+Vuhare4uZfuubFfVPlcAkynes05T1IPluqLxkp2SZTd1h6r
         +oG86s9asj7Y03G+idayokQ0hkC38PyFdk8A9IYY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201109084227epcas1p29f6f1eef646ef1c010aa70e3adb688ea~Fyl4CYj4B1667516675epcas1p29;
        Mon,  9 Nov 2020 08:42:27 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.166]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4CV4Hk124DzMqYm6; Mon,  9 Nov
        2020 08:42:26 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        18.47.09577.2F009AF5; Mon,  9 Nov 2020 17:42:26 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20201109084225epcas1p3522cb6e6b277e76055403b83f6b55a2b~Fyl2jT7rt0434404344epcas1p33;
        Mon,  9 Nov 2020 08:42:25 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201109084225epsmtrp2fd55965dcd03c7f8e9dd6b0af6c23a3b~Fyl2iqcp12492624926epsmtrp2k;
        Mon,  9 Nov 2020 08:42:25 +0000 (GMT)
X-AuditID: b6c32a39-bfdff70000002569-65-5fa900f2bf59
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        EB.73.08745.1F009AF5; Mon,  9 Nov 2020 17:42:25 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201109084225epsmtip172f3f84cf83d4486341af96529009f13~Fyl2aRu0_1932319323epsmtip1J;
        Mon,  9 Nov 2020 08:42:25 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Namjae Jeon <namjae.jeon@samsung.com>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH] cifs: fix a memleak with modefromsid
Date:   Mon,  9 Nov 2020 17:35:33 +0900
Message-Id: <20201109083533.2701-1-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsWy7bCmnu4nhpXxBrs3s1q8+L+L2eLH9HqL
        Ny8Os1ks2PiI0YHFY+esu+wefVtWMXp83iQXwByVY5ORmpiSWqSQmpecn5KZl26r5B0c7xxv
        amZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtExJoSwxpxQoFJBYXKykb2dTlF9akqqQkV9cYquU
        WpCSU2BoUKBXnJhbXJqXrpecn2tlaGBgZApUmZCTce+AasEsvooX8/ewNjA28nQxcnJICJhI
        zN4xkamLkYtDSGAHo8T37l5mCOcTo8SteT2MEM5nRon9bU/ZYFreNq9nh0jsYpR4tvoAC1xL
        e1sT0DAODjYBbYk/W0RBGkQE5CTWbjrJAmIzCyRI7F2zFWyQsICpxLEbu9hBbBYBVYnJvy+w
        g7TyClhL7JtjCrFLXmL1hgNgF0kItLNLLPkFch5IwkVix8EVrBC2sMSr41vYIWwpic/v9rKB
        zJEQqJb4uB+qvINR4sV3WwjbWOLm+g2sICXMApoS63fpQ4QVJXb+nssIcSWfxLuvPawQU3gl
        OtqEIEpUJfouHWaCsKUluto/QC31kGhftAfsQSGBWImNa7+yTWCUnYWwYAEj4ypGsdSC4tz0
        1GLDAlPkGNrECE49WpY7GKe//aB3iJGJg/EQowQHs5IIr9O/FfFCvCmJlVWpRfnxRaU5qcWH
        GE2BoTWRWUo0OR+Y/PJK4g1NjYyNjS1MzMzNTI2VxHn/aHfECwmkJ5akZqemFqQWwfQxcXBK
        NTBtW6fxafXmWs+AKXltrhXtXittmw8GhAf//lLWzG0zwTrC3uzBE/YDR1JerV0XFms/OcZu
        UeNupW93Y/uX/0maJ1H7VqBLcGvIzj1xP7o/n72cKvt2abe2GotDw4aV3/fkuP8/XRMu5ff3
        +Fzbxs+MqoJTfAMkjVI3JYSnHf8t0MK1cOfGFx0coiWp76Z7GtwoXWyVVq3uprvS68Sa4KfL
        Dn2Y/FDmQbRC3XHZD/P9Yz+rHY8PrA2e5ii7fGbhG8+7t858ub1W6crpbwlHD9273r3tZUPv
        rvMNYe9SSgs53NdfrF6mbsjV0Xd091SPg9cPnj9dsuNn746JcrYfE+YoVQhu3Hs0xfnKf6d9
        G7r3KLEUZyQaajEXFScCAIjjBJvGAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJMWRmVeSWpSXmKPExsWy7bCSnO5HhpXxBhs3a1q8+L+L2eLH9HqL
        Ny8Os1ks2PiI0YHFY+esu+wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXHvgGrBLL6KF/P3
        sDYwNvJ0MXJySAiYSLxtXs/excjFISSwg1Hi/dkt7BAJaYljJ84wdzFyANnCEocPF0PUfGCU
        2LnpDhtInE1AW+LPFlGQchEBOYm1m06ygISZBZIkZl+sAgkLC5hKHLuxC2wii4CqxOTfF9hB
        SngFrCX2zTGFWCQvsXrDAeYJjDwLGBlWMUqmFhTnpucWGxYY5aWW6xUn5haX5qXrJefnbmIE
        B4KW1g7GPas+6B1iZOJgPMQowcGsJMLr9G9FvBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHer7MW
        xgkJpCeWpGanphakFsFkmTg4pRqYpr06ujaCSVRu/QKdQ+sNN7GVcz9Jfzgv6/2MsBPLy36f
        8Vh8oT9BxeT02Qo91secYRGTu+atYmM69/T7xcAkY57a6ovttjsjfqv9W+JU6ZF8RiWEq5LD
        Zkv3+j1vP69fXBu3cIJAYDTDES3pw8k8q9+ezkxUr4tZpfHExDLNfVsuBydjfOvJVz4PeOK0
        G++XOHo1/55QfJ79/5SVrPqS65qrmpO3hU3/tkE72eBX1EfBGQGlKtO9d+ckP1rIl+21rVRY
        qNgzya/PpqhW/uL+/OUT3k62P3rcmHm6hNhxt9kG5vcKLuvZC3n6sovoeDMZ8s+e0HXm8aaD
        p48Geyxd+4bvtcTmJz6Zc+3fOc9WYinOSDTUYi4qTgQAYEtEsXMCAAA=
X-CMS-MailID: 20201109084225epcas1p3522cb6e6b277e76055403b83f6b55a2b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201109084225epcas1p3522cb6e6b277e76055403b83f6b55a2b
References: <CGME20201109084225epcas1p3522cb6e6b277e76055403b83f6b55a2b@epcas1p3.samsung.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

kmemleak reported a memory leak allocated in query_info() when cifs is
working with modefromsid.

  backtrace:
    [<00000000aeef6a1e>] slab_post_alloc_hook+0x58/0x510
    [<00000000b2f7a440>] __kmalloc+0x1a0/0x390
    [<000000006d470ebc>] query_info+0x5b5/0x700 [cifs]
    [<00000000bad76ce0>] SMB2_query_acl+0x2b/0x30 [cifs]
    [<000000001fa09606>] get_smb2_acl_by_path+0x2f3/0x720 [cifs]
    [<000000001b6ebab7>] get_smb2_acl+0x75/0x90 [cifs]
    [<00000000abf43904>] cifs_acl_to_fattr+0x13b/0x1d0 [cifs]
    [<00000000a5372ec3>] cifs_get_inode_info+0x4cd/0x9a0 [cifs]
    [<00000000388e0a04>] cifs_revalidate_dentry_attr+0x1cd/0x510 [cifs]
    [<0000000046b6b352>] cifs_getattr+0x8a/0x260 [cifs]
    [<000000007692c95e>] vfs_getattr_nosec+0xa1/0xc0
    [<00000000cbc7d742>] vfs_getattr+0x36/0x40
    [<00000000de8acf67>] vfs_statx_fd+0x4a/0x80
    [<00000000a58c6adb>] __do_sys_newfstat+0x31/0x70
    [<00000000300b3b4e>] __x64_sys_newfstat+0x16/0x20
    [<000000006d8e9c48>] do_syscall_64+0x37/0x80

This patch add missing kfree for pntsd when mounting modefromsid option.

Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 fs/cifs/cifsacl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 23b21e943652..ef4784e72b1d 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1266,6 +1266,7 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
 		cifs_dbg(VFS, "%s: error %d getting sec desc\n", __func__, rc);
 	} else if (mode_from_special_sid) {
 		rc = parse_sec_desc(cifs_sb, pntsd, acllen, fattr, true);
+		kfree(pntsd);
 	} else {
 		/* get approximated mode from ACL */
 		rc = parse_sec_desc(cifs_sb, pntsd, acllen, fattr, false);
-- 
2.17.1

