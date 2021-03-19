Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234CA34162C
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 07:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbhCSG6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 02:58:34 -0400
Received: from out28-2.mail.aliyun.com ([115.124.28.2]:51983 "EHLO
        out28-2.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234068AbhCSG6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 02:58:25 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.08128843|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0126591-0.000135465-0.987205;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047187;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=9;RT=9;SR=0;TI=SMTPD_---.JnAP104_1616137096;
Received: from 192.168.88.129(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.JnAP104_1616137096)
          by smtp.aliyun-inc.com(10.147.42.22);
          Fri, 19 Mar 2021 14:58:18 +0800
Subject: Re: [PATCH] I2C: JZ4780: Fix bug for Ingenic X1000.
To:     Wolfram Sang <wsa@kernel.org>
Cc:     paul@crapouillou.net, stable@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, sernia.zhou@foxmail.com
References: <1616084743-112402-1-git-send-email-zhouyanjie@wanyeetech.com>
 <1616084743-112402-2-git-send-email-zhouyanjie@wanyeetech.com>
 <20210318170623.GA1961@ninjato>
From:   Zhou Yanjie <zhouyanjie@wanyeetech.com>
Message-ID: <644d19d8-9444-4dde-a891-c9dfd523389e@wanyeetech.com>
Date:   Fri, 19 Mar 2021 14:58:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20210318170623.GA1961@ninjato>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Wolfram,


Sorry, please forgive my carefulness, I wrongly sent the version that 
did not clean up, resulting in missing the reporter's information and 
some errors in formats.


On 2021/3/19 上午1:06, Wolfram Sang wrote:
> On Fri, Mar 19, 2021 at 12:25:43AM +0800, 周琰杰 (Zhou Yanjie) wrote:
>> Only send "X1000_I2C_DC_STOP" when last byte, or it will cause
>> error when I2C write operation.
> Any write operation? I wonder then why nobody noticed before?


The standard I2C communication should look like this:

Read:

device_addr + w, reg_addr, device_addr + r, data;

Write:

device_addr + w, reg_addr, data;


But without this patch, it looks like this:

Read:

device_addr + w, reg_addr, device_addr + r, data;

Write:

device_addr + w, reg_addr, device_addr + w, data;

This is clearly not correct.


When I added support for X1000 to this driver, the hardware used was 
CU1000-Neo. On this hardware, there was an ADS7830 that communicated 
through I2C, but the operation of ADS7830 only involved read operations, 
so I was at that time failed to realize the problem with the write 
operation.
In addition, because X1000 did not implement relatively complete support 
in the mainline until the second half of 2020, there are still a large 
number of users who are still using the old SDK (kernel 3.10 and 
kernel4.4) provided by Ingenics, which may also be indirectly delayed 
exposure of this problem.


>> -			while ((i2c_sta & JZ4780_I2C_STA_TFNF) &&
>> -					(i2c->wt_len > 0)) {
>> +			while ((i2c_sta & JZ4780_I2C_STA_TFNF) && (i2c->wt_len > 0)) {
> This is a cosmetic change only IIUC. Shouldn't be in a bugfix.
>

My fault, I will remove it in the next version.


Thanks and best regards!


