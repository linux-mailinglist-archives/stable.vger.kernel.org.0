Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91624523050
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 12:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbiEKKJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 06:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241014AbiEKKJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 06:09:23 -0400
X-Greylist: delayed 359 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 11 May 2022 03:09:13 PDT
Received: from email.studentenwerk.mhn.de (dresden.studentenwerk.mhn.de [141.84.225.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2C17A828;
        Wed, 11 May 2022 03:09:12 -0700 (PDT)
Received: from mailhub.studentenwerk.mhn.de (mailhub.studentenwerk.mhn.de [127.0.0.1])
        by email.studentenwerk.mhn.de (Postfix) with ESMTPS id 4Kyr7z1hfMzRhSb;
        Wed, 11 May 2022 12:03:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stwm.de; s=stwm-20170627;
        t=1652263391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=paHzsJSUUUK2l3doauEwUmwh24Gg8aqJ/AhHP760snk=;
        b=Qp5JKFdwGYj8Gar70vooSb2H3bWE0kAS4UYpnePxXIykfKcymrLtiBPn/7Ux5zAKL6MUkD
        ZQbx+twkue0/4TpKQl+UbCjWIAhbGkX6L7mJez7jwUQ3ySD+cHYwwnoXfiD8AE1LOuOXQF
        Zd7zp0mc3Mly/9duv2GsTMfspRsupIUj6nD0hh1E8R6zFyKO7xT4YuwGVAu0nTbjIhkNX+
        wIh40zOoBSCvn/PcE2sAQ6dtDR+0Ykq37clezF892Ak+iW4Wx0FJQbG6s7HPqFy0oFLvA3
        KIZt83R8J7V2qEt62wEKmWbS5H+O557uF9Vpg08ivGGLStoz+ej7h+LWGyviYA==
MIME-Version: 1.0
Date:   Wed, 11 May 2022 12:03:13 +0200
From:   Wolfgang Walter <linux@stwm.de>
To:     stable@vger.kernel.org, Trond Myklebust <trondmy@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 5.4.188 and later: massive performance regression with nfsd
Message-ID: <f8d9b9112607df4807fba8948ac6e145@stwm.de>
X-Sender: linux@stwm.de
Organization: =?UTF-8?Q?Studentenwerk_M=C3=BCnchen?=
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

starting with 5.4.188 wie see a massive performance regression on our 
nfs-server. It basically is serving requests very very slowly with cpu 
utilization of 100% (with 5.4.187 and earlier it is 10%) so that it is 
unusable as a fileserver.

The culprit are commits (or one of it):

c32f1041382a88b17da5736886da4a492353a1bb "nfsd: cleanup 
nfsd_file_lru_dispose()"
628adfa21815f74c04724abc85847f24b5dd1645 "nfsd: Containerise filecache 
laundrette"

(upstream 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63 and 
9542e6a643fc69d528dfb3303f145719c61d3050)

If I revert them in v5.4.192 the kernel works as before and performance 
is ok again.

I did not try to revert them one by one as any disruption of our 
nfs-server is a severe problem for us and I'm not sure if they are 
related.

5.10 and 5.15 both always performed very badly on our nfs-server in a 
similar way so we were stuck with 5.4.

I now think this is because of 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63 
and/or 9542e6a643fc69d528dfb3303f145719c61d3050 though I didn't tried to 
revert them in 5.15 yet.


Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
