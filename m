Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56D133CD43
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 06:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhCPFYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 01:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235439AbhCPFYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 01:24:41 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03057C06174A
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 22:24:41 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ga23-20020a17090b0397b02900c0b81bbcd4so777886pjb.0
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 22:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=nHDKK9cwB/SVmiSnX7QLelhy9j7mhfcxFHJqI3Khacs=;
        b=FaM5aznThi/Cgu4Va8fl94WeDz5uwJMDsna460YrUPfhFdA1fI+NOXADL3e3rUfGbW
         eo8qeGg336sK04LNRhVtZ5Og9sjqKbCzqopK6sIpHlMzHNxaFsHBv/dvaR/MAwtsgqKc
         0CcNAocg/eESDKnPuKkWBazwfPiLYALUluOBOFYXK1eUV2UJ/DfIQRr7RCt0weOjKYvd
         eLmiOaPSeNeIqiB6xJE0uQZ52ZnqzojA+b7DI5ERsdKswaVjBrLAbbyFdHSEWncDSp73
         ywcDtKkNDKDk404oDOs0mkrVZqYASaDftB+qSqlwz0TnLdf5shwNyJQAodJYfAIg3PHj
         KbUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=nHDKK9cwB/SVmiSnX7QLelhy9j7mhfcxFHJqI3Khacs=;
        b=XY723WCFCdW2JIqUrJquv3a9UQHjoo/e8oqXssakhM6SJgrRdW4srjsupng1AW4nJK
         LdzHzuKShgIm/7218zG/w5jgZ52f0LKM12lFqyMC6VkPmKev/dUUARabZAw4NV3VxcYu
         JRoTwOzZPGMBvWmTTcDE5WSj7FLlabXa4eBQqztW3dFxj5Ji0h/DK0uiO3YO9iSLFWFJ
         G7397GET0R1zdkNzpyVRmLUqtJ2/IXQ9kvz54dd5dpuiy7FrSXYhtyWdwlX6609GiUdA
         6n9pdkFZvwceJCQs9Ewkszdn/vgJkDmTLccxiCypKz9AAB7TnR5kBLs3HryTb3HGgUV1
         N5wg==
X-Gm-Message-State: AOAM5327VAs0lG082WOT5zTqaMEPES9Byxwprukm4s/PDoStwHrIFfPq
        jYWlQSVVjVLRyBdfVhfih3+Obs8dz8g2eHmp
X-Google-Smtp-Source: ABdhPJxdFIh2RcvQ+wNCfHdesE9OhV17xfZUf7YATzIjbnzVrNR/MK3vblyzi1YLUPO+FOJEuFKVRQ==
X-Received: by 2002:a17:903:304e:b029:e5:d43:9415 with SMTP id u14-20020a170903304eb02900e50d439415mr14861378pla.42.1615872280306;
        Mon, 15 Mar 2021 22:24:40 -0700 (PDT)
Received: from houpudeMacBook-Pro.local ([61.120.150.74])
        by smtp.gmail.com with ESMTPSA id t10sm1374663pjf.30.2021.03.15.22.24.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 22:24:39 -0700 (PDT)
Subject: Re: [PATCH] nvmet-tcp: finish receiving before send back response if
 nvmet_req_init() failed.
To:     Sagi Grimberg <sagi@grimberg.me>, hch@lst.de,
        chaitanya.kulkarni@wdc.com
Cc:     linux-nvme@lists.infradead.org, stable@vger.kernel.org
References: <20210315100928.87596-1-houpu.main@gmail.com>
 <3a5bd33b-32c2-24c4-3880-883e33bfe282@grimberg.me>
From:   Hou Pu <houpu.main@gmail.com>
Message-ID: <a4ae0e4b-3d59-3a5a-1533-4545e2e4633e@gmail.com>
Date:   Tue, 16 Mar 2021 13:24:34 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <3a5bd33b-32c2-24c4-3880-883e33bfe282@grimberg.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2021/3/16 1:32 AM, Sagi Grimberg wrote:
>
>> When receiving a pdu, if nvmet_req_init() failed (for example a ns is
>> not found), the queue->rcv_state could be moved to NVMET_TCP_RECV_DATA
>> by nvmet_tcp_handle_req_failure(). We should return 0 here to continue
>> to consume the possible remaining inline write out data in
>> nvmet_tcp_try_recv_one(). Otherwise, the response to this request would
>> be sent and iov would be freed. Next time in nvmet_tcp_try_recv_one(),
>> we would go to the receiving data phase and the iov is used again.
>>
>> A panic happend with a 5.4 kernel installed as below:
>
> Can you please try to reproduce this with upstream? and with latest
> stable 5.4? there have been some fixes in this area. We may need
> to help backported patches to stable if needed.


This could be reproduced on the latest stable (5.4.105).  I tried with 
upstream

(5.12-rc3), it could not be reproduced. But I thought the bug still 
exist in upstream,

then I added the following changes to catch such use after problems.


diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 8b0485ada315..46847ccf4395 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -217,6 +217,16 @@ static inline void nvmet_tcp_put_cmd(struct 
nvmet_tcp_cmd *cmd)
         list_add_tail(&cmd->entry, &cmd->queue->free_list);
  }

+static inline bool nvmet_tcp_cmd_freed(struct nvmet_tcp_cmd *cmd)
+{
+       /* When a cmd is first geted, list_del_init() is called, it could be
+        * used to tell if it is on free list
+        */
+       if (cmd->entry.next == &cmd->entry && cmd->entry.prev == 
&cmd->entry)
+               return false;
+       return true;
+}
+
  static inline int queue_cpu(struct nvmet_tcp_queue *queue)
  {
         return queue->sock->sk->sk_incoming_cpu;
@@ -1088,6 +1098,9 @@ static int nvmet_tcp_try_recv_data(struct 
nvmet_tcp_queue *queue)
         struct nvmet_tcp_cmd  *cmd = queue->cmd;
         int ret;

+       if (nvmet_tcp_cmd_freed(cmd))
+               pr_err("cmd=%p which is freed is used again\n", cmd);
+
         while (msg_data_left(&cmd->recv_msg)) {
                 ret = sock_recvmsg(cmd->queue->sock, &cmd->recv_msg,
                         cmd->recv_msg.msg_flags);

The dmesg shows:

[   80.058535] nvmet_tcp: failed cmd 0000000074710fda id 83 opcode 1, 
data_len: 1024
[   80.060225] nvmet_tcp: cmd=00000000b470d96a which is freed is used again
[   80.060903] nvmet_tcp: failed cmd 000000007d648e5e id 84 opcode 1, 
data_len: 1024
[   80.061377] nvmet_tcp: cmd=000000002f3194cb which is freed is used again
[   80.061656] nvmet_tcp: failed cmd 0000000047cc966a id 85 opcode 2, 
data_len: 1024
[   80.066657] nvmet_tcp: failed cmd 000000005319c9b2 id 86 opcode 1, 
data_len: 1024
[   80.067325] nvmet_tcp: cmd=00000000245c70d6 which is freed is used again

So, I think the upstream also has this bug.


How to reproduce:

1. Runing fio from initiator:

fio -bs=1024 -filename=/dev/nvme1n1 -rw=randrw -direct=1 
-ioengine=libaio -numjobs=4 -time_based=1 -runtime=600 -iodepth=1 -name=t

2. disable namespace 1 from target by :

echo 0 > /sys/kernel/config/nvmet/subsystems/mysub/namespaces/1/enable

[..]

>>
>>   drivers/nvme/target/tcp.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
>> index 8b0485ada315..da1c667e21ba 100644
>> --- a/drivers/nvme/target/tcp.c
>> +++ b/drivers/nvme/target/tcp.c
>> @@ -961,7 +961,7 @@ static int nvmet_tcp_done_recv_pdu(struct 
>> nvmet_tcp_queue *queue)
>> le32_to_cpu(req->cmd->common.dptr.sgl.length));
>>             nvmet_tcp_handle_req_failure(queue, queue->cmd, req);
>> -        return -EAGAIN;
>> +        return 0;
>
> What guarantees that you will actually have more to consume?


In my case, write 1024 bytes request need receive inline data.

After receive cmd pdu, the following inline data still need to be read 
from the socket.


Thanks,

Hou


