Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70F3547321
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 11:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbiFKJW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 05:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiFKJW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 05:22:27 -0400
X-Greylist: delayed 452 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 11 Jun 2022 02:22:18 PDT
Received: from poutre.nerim.net (poutre.nerim.net [178.132.16.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 85EAD2E2
        for <stable@vger.kernel.org>; Sat, 11 Jun 2022 02:22:18 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by poutre.nerim.net (Postfix) with ESMTP id 7E2B139DE55
        for <stable@vger.kernel.org>; Sat, 11 Jun 2022 11:14:42 +0200 (CEST)
X-Virus-Scanned: amavisd-new at nerim.net
Received: from poutre.nerim.net ([127.0.0.1])
        by localhost (poutre.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZOB2hsYeVF21 for <stable@vger.kernel.org>;
        Sat, 11 Jun 2022 11:14:40 +0200 (CEST)
Received: from [192.168.0.250] (plouf.fr.eu.org [213.41.155.166])
        by poutre.nerim.net (Postfix) with ESMTP id 8518439DE65
        for <stable@vger.kernel.org>; Sat, 11 Jun 2022 11:14:39 +0200 (CEST)
Message-ID: <9257c1c4-d052-9e05-9016-8321c2cc47c6@plouf.fr.eu.org>
Date:   Sat, 11 Jun 2022 11:14:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To:     stable@vger.kernel.org
Content-Language: en-US
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Subject: md/raid0: Ignore RAID0 layout if the second zone has only one device
Organization: Plouf !
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply
Upstream commit ea23994edc4169bd90d7a9b5908c6ccefd82fa40
to kernel versions 4.14, 4.19, 5.4 and above.

Reason:
Commits c84a1372df929033cb1a0441fb57bd3932f39ac9 "md/raid0: avoid RAID0 
data corruption due to layout confusion." and 
33f2c35a54dfd75ad0e7e86918dcbe4de799a56c "md: add feature flag 
MD_FEATURE_RAID0_LAYOUT" added handling of original and alternate 
layouts of RAID0 arrays with members of different sizes. However they 
introduced a regression: assembly of such RAID0 array fails if the 
per-array or default layout is not defined even when the layout is 
irrelevant and can be safely ignored. One common case is when the RAID0 
array is composed of two members of different sizes because the disk or 
partition sizes are slightly different. This patch aims to fix this 
regression.

Newer versions of mdadm can set a per-array RAID0 layout but some stable 
distributions such as Debian 10 ship an older version of mdadm which 
does not handle RAID0 layouts and a kernel series (4.19.y) which now 
includes the backported commits. As a result, assembly fails after the 
kernel upgrade unless the default layout is defined with a kernel parameter.

Related Debian bug reports :
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=944676
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=954816
