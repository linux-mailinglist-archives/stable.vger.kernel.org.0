Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C1A50260E
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 09:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350919AbiDOHRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 03:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241498AbiDOHRf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 03:17:35 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B96BAAB44;
        Fri, 15 Apr 2022 00:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1650006898;
        bh=Zu+5OndlwunlHNDkUTl8uFCfZamK3t5tqw0BjhepadE=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=Qp2KXlbjfhxSHK88KmZsBa6Zy/j3x03f5V+eLLnx3ENq5z1wOQk3TkSpod7gvPnNy
         3F23cw3EumeZ7rvC9pqL7nSSOO2PvYaGVCZOLrcmRK4yhsWv3MWT9SXPN5NhQh6oNR
         Qqrb0l3lzCS9dtHSG67wZNAY3eBAlm3V7Eqf+QrM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1McpJg-1oF8x13L18-00Zwi1; Fri, 15
 Apr 2022 09:14:58 +0200
Message-ID: <7e60b890-939b-c5c1-715e-3262793ef079@gmx.com>
Date:   Fri, 15 Apr 2022 15:14:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 1/3] btrfs: avoid double clean up when submit_one_bio()
 failed
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
References: <cover.1649766550.git.wqu@suse.com>
 <0b13dccbc4d6e066530587d6c00c54b10c3d00d7.1649766550.git.wqu@suse.com>
 <YlkQgTCv+Iw2QzPz@infradead.org>
 <37226b35-7d5a-dd86-7b20-7a0dfd3b96fc@gmx.com>
 <YlkayiTPf93aBpSD@infradead.org>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <YlkayiTPf93aBpSD@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:2Hy8b5sCWfk66Q4D79HL6l32Cxnct09Fiqe62lisdr3uB9laaKN
 xBWYbrIYg5twzHobm5bKApOamoaRq1vhVTsdcuBibMFgutqUiP6HnJWqvmt4FeKPT3MzICh
 hgOvH6eNkHUlFyoTfiRWt5LJSD8uLMo+rZKO8OuEhFVXNkj+gJJrXIYvwoI51Aa06qefSwm
 fmZJLPQtay5u4bUYvqRIg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:M6C15kOqZow=:4sZYxSCgSxflE6z0QkrVM7
 sbkvdEw9Lmy8ECtT9lIxcCJ8YvEuXZx4yzT8vRy3GJYINLtqvN5Rp1HMNKFe6bxxpT/zX/JJP
 n6aVnng6/o5l9o/0LVEZG4a3ZaMfOfmShqrTuY7Dq5FoOwM3Li+duZznCAbuuGb9/qO4NUhqZ
 C9oc49wU6v+6e5GJqNeWuk6yur8m9FiZJZV1sjZIbPdwhZg0eMPkQqvHKbGjDwxJ8KaFXokbk
 E30NqxWHIxpnPffwB96z8/+GSKKkat59nxNgFZ9JKqlekxh5DlJo5ofapuNqWjLzbk8A/fp2j
 n+c/woWxvHy80i+hM58wHPYBYPS7GWefOvI/eNu5Ljm3ZS9KmcvNRDB0C75tRr8WLVzUaTyHQ
 jC9/KvWE+XXj8/DCcQJkk0JT16alkCgIVD+w0Oe9i0u20pGeaVT/C3xPJ7ezlYxC/RxKxP8SJ
 EjUCVB4EffHv8g29oz4f41h30m11jdUW6TjfHRlYNTkfotEK8J9bYHdDmaHoG+tspZqgrJryg
 fu5qGYuscW6fH9sFwZN5yIF7msCW5XVsA0Q8dDbX9epvY4PJLzdxkB5ztImdXAl62gUfBk1HV
 Z7y6DSX7fL/I+61cVLSYqmRP0fWZwCuxWTXH1DcrC8yiRG7f3/NR0FFRwugnHzUY3btQCtje1
 K/Y7/QMnuyF8Lv0rgmBIRmkwxHHHhvlN+nMpCCTLpAG4o6tNs/09YHGzpSpruC1o6Eg6nRzbJ
 XCHijQn4G39xf/oFDiadlcq0hRi26usPgqY3As7xErjjXp8J6lH8dnSbBzMUqRq4/0iZlk8Q4
 3NT4lQlanF3x0IHvb7kkCKkzWs5Z9KakGOSCfwHjkOplLyINhcNmwGa+swgg94KVC+ggvnOo4
 1WA0SUW5KgxiOm2kME+ZE0rMu9IudQflMy3TTzJla7y40JBBntRC4poR73d0a7BcnsMCBU5uT
 zFLKVAbtYTIHV4lgkEMcjEPnRhJY0jVI8ehnqph7IbJXqILle7HhltFo1n7XG3dvCj2VjjrKR
 WEVFC2frdFsGYOhZgPJOsfR2YP3R1iV0fMxGbywQ1U5+Y4zZ2NJphLAMkbiGtH26HJ/uMWtT6
 kjGISo1gKK2be8=
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/4/15 15:12, Christoph Hellwig wrote:
> On Fri, Apr 15, 2022 at 03:02:41PM +0800, Qu Wenruo wrote:
>> But this can not be said to btrfs_submit_compressed_read(), which has
>> the same problem and can be triggered by EIO error easily.
>>
>> Do you want to give it a try? Or mind to me fix it?
>
> I don't really know the btrfs writeback and compression code very well,
> so if you can tackle it that would be great.  I'll review it and will
> ask lots of stupid question in exchange :)

No stupid questions at all.

Great we have some extra reviewing eyes!

Thanks for your review in advance.
Qu
