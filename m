Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B604F7D2B
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 12:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbiDGKmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 06:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244599AbiDGKmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 06:42:54 -0400
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3C913FA4
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 03:40:54 -0700 (PDT)
Received: from [192.168.43.47] (unknown [37.165.165.88])
        (Authenticated sender: achtol@free.fr)
        by smtp4-g21.free.fr (Postfix) with ESMTPSA id 6685D19F576
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 12:40:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1649328052;
        bh=QfDCeaBExGzeH/KQHc/DLb5QDOV0gbRBtodawwLWXYg=;
        h=Date:To:From:Subject:From;
        b=smA3CgAmBRkvhUZ3IBUgyaSp6HBRH4VE02nZlrrZTGOv0TMWKBCcKvojSNY4Vrszc
         YHI30Nxm10mh+mzjtNFOHYbZeW9A0D42ds+geF5qyUpRN+WZox6iqFrpEbyQh3scdx
         OzKuD0gVX4GVfedwsvpUN6eKGXrDQ77qE1IRQ5T8xspdQPbOszXIb2vB2dIj7pZOo6
         dMOA+UZzyvO4YKpmn5wt5kfIYgnDgQtSE1sz+BuTu6a/YT+V2LjiDoNxoz6jNCMskt
         bjFDXl+U3zQ9nvS2iLLJB3JDnj0qrD/eXGxINBOgO9U5BC74LA6xH9S5KiBotG3KPD
         UZr9OtjjWyveg==
Message-ID: <a362b7bc-8b30-bbe6-de37-9cc01cf42d9c@free.fr>
Date:   Thu, 7 Apr 2022 12:40:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     stable@vger.kernel.org
From:   achtol <achtol@free.fr>
Subject: CVE-2020-16120 and CVE-2021-3428
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

It seems the fix commits for a couple of CVEs have not been cherry 
picked in the current linux-5.4.y branch (v5.4.188, currently):

---

CVE-2020-16120:

<https://nvd.nist.gov/vuln/detail/CVE-2020-16120> references the 
following mainline commits:

     d1d04ef8572bc8c22265057bd3d5a79f223f8f52 "ovl: stack file ops" 
(break commit)
     56230d956739b9cb1cbde439d76227d77979a04d "ovl: verify permissions 
in ovl_path_open()"
     48bd024b8a40d73ad6b086de2615738da0c7004f "ovl: switch to mounter 
creds in readdir"
     05acefb4872dae89e772729efb194af754c877e8 "ovl: check permission to 
open real file"
     b6650dab404c701d7fe08a108b746542a934da84 "ovl: do not fail because 
of O_NOATIME"

The CVE description says the last commit in the list above fixes a 
regression introduced by these two commits:

     130fdbc3d1f9966dd4230709c30f3768bccd3065 "ovl: pass correct flags 
for opening real directory"
     292f902a40c11f043a5ca1305a114da0e523eaa3 "ovl: call secutiry hook 
in ovl_real_ioctl()"

---

CVE-2021-3428:

According to <https://bugzilla.suse.com/show_bug.cgi?id=1173485>, the 
mainline fix commits are:

     d176b1f62f24 "ext4: handle error of ext4_setup_system_zone() on 
remount"
     bf9a379d0980 "ext4: don't allow overlapping system zones"
     ce9f24cccdc0 "ext4: check journal inode extents more carefully"

Of these, only the first two have been cherry-picked.

---

Half of these commits may be cherry-picked without a conflict. I wonder 
why they have not been applied and cannot find any discussion about them 
on this mailing list. Is it an oversight? Or because the v5.4 line is 
not affected? Some other reason?

Regards,

achtol

