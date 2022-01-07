Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8284876C2
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 12:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238037AbiAGLsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 06:48:30 -0500
Received: from smtp21.cstnet.cn ([159.226.251.21]:39028 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347196AbiAGLsa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jan 2022 06:48:30 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-01 (Coremail) with SMTP id qwCowAAnLZ12KNhhNbz4BQ--.12135S2;
        Fri, 07 Jan 2022 19:48:06 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     David.Laight@ACULAB.COM, damien.lemoal@opensource.wdc.com,
        davem@davemloft.net
Cc:     linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: Re: Re: [PATCH v2] ide: Check for null pointer after calling devm_ioremap
Date:   Fri,  7 Jan 2022 19:47:58 +0800
Message-Id: <20220107114758.4057401-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: qwCowAAnLZ12KNhhNbz4BQ--.12135S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Gry7AryUAw1xAFWDGr4rXwb_yoW3Jrc_C3
        93ZanrWrZ0yr17JwsrGw12vrW2yF4rWrZxtrZ8twsxXr9rurnrGryY9wsYva1xW3s2vrn3
        uFsxZayakw1jkjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbc8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s
        1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0
        cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8Jw
        ACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r4kMxAI
        w28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
        4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxG
        rwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8Jw
        CI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY
        6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU0PEfUUUUU
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 07, 2022 at 05:28:59PM +0800, David Laight wrote:
> That !!alt_base doesn't look right.
> Without looking at the rest of the code maybe:
> 	if (!base && !alt_base)
> may be correct.

Thanks, that's my fault.
I will correct it.

> It also rather makes me wonder about the actual failure return value.
> If devm_ioport_map() returns a 'port number' for inb()/outb() then
> zero is technically a valid value!

That's not right.
The devm_ioport_map() returns NULL if fails and returns non-NULL
pointer if success.
And also we can find in `drivers/ata/pata_platform.c` that it also
use the same way to check the return value from devm_ioport_map().

I will submit a new version to correct my code.

Sincerely thanks,
Jiang

